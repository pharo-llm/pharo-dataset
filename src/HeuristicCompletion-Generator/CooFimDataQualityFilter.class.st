"
I filter and clean FIM (Fill-in-the-Middle) dataset entries to improve data quality.
I implement the following quality rules:
  1. Remove entries with empty targets
  2. Remove entries with very short targets (configurable minimum length)
  3. Deduplicate exact (prefix, suffix, target) triples
  4. Near-deduplicate entries from the same method region
  5. Cap the number of examples per source method
  6. Prefer token-boundary cuts (targets starting at word boundaries)
Usage:
  filter := CooFimDataQualityFilter new.
  filter minTargetLength: 3.
  filter maxExamplesPerMethod: 5.
  cleanedEntries := filter filter: exporter entries.
"
Class {
	#name : 'CooFimDataQualityFilter',
	#superclass : 'Object',
	#instVars : [
		'minTargetLength',
		'maxExamplesPerMethod',
		'nearDuplicateWindowSize',
		'preferTokenBoundary'
	],
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'accessing' }
CooFimDataQualityFilter class >> default [

	^ self new
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> addMetadataTo: entry [
	"Add quality metadata fields to an entry for later analysis.
	 Returns the entry with added metadata (modifies in place)."

	| target prefix |
	target := entry at: #target ifAbsent: [ entry at: #correct ifAbsent: [ '' ] ].
	prefix := entry at: #context ifAbsent: [ '' ].
	entry at: #targetLength put: target size.
	entry at: #isTokenBoundary put: (self isTokenBoundaryTarget: entry).
	entry at: #targetKind put: (self classifyTarget: target).
	^ entry
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> capPerMethod: entries [
	"Limit the number of entries per source method.
	 Groups entries by their method source (approximated by the first line
	 of the prefix context) and keeps at most maxExamplesPerMethod per group."

	| groups result |
	groups := Dictionary new.
	entries do: [ :entry |
		| key |
		key := self methodKeyFor: entry.
		(groups at: key ifAbsentPut: [ OrderedCollection new ]) add: entry ].
	result := OrderedCollection new.
	groups valuesDo: [ :group |
		result addAll: (group first: (maxExamplesPerMethod min: group size)) ].
	^ result
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> classifyTarget: target [
	"Classify the target into a syntactic category for stratification."

	target isEmpty ifTrue: [ ^ #empty ].
	(target first isUppercase and: [ target allSatisfy: [ :c | c isAlphaNumeric ] ])
		ifTrue: [ ^ #globalOrClass ].
	(target allSatisfy: [ :c | c isAlphaNumeric or: [ c = $: ] ])
		ifTrue: [
			(target includes: $:)
				ifTrue: [ ^ #keywordSelector ]
				ifFalse: [ ^ #identifier ] ].
	(target size <= 2 and: [ target allSatisfy: [ :c | c isLetter not ] ])
		ifTrue: [ ^ #operator ].
	^ #mixed
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> deduplicateExact: entries [
	"Remove exact duplicates based on (prefix, suffix, target) triple."

	| seen result |
	seen := Set new.
	result := OrderedCollection new.
	entries do: [ :entry |
		| key |
		key := self exactKeyFor: entry.
		(seen includes: key) ifFalse: [
			seen add: key.
			result add: entry ] ].
	^ result
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> deduplicateNear: entries [
	"Remove near-duplicate entries that share the same method region.
	 Two entries are near-duplicates if the trailing window of their prefix
	 (last nearDuplicateWindowSize characters) and the leading window of
	 their suffix are identical."

	| seen result |
	seen := Set new.
	result := OrderedCollection new.
	entries do: [ :entry |
		| key |
		key := self nearKeyFor: entry.
		(seen includes: key) ifFalse: [
			seen add: key.
			result add: entry ] ].
	^ result
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> exactKeyFor: entry [
	"Compute a deduplication key from the (prefix, suffix, target) triple."

	| prefix suffix target |
	prefix := entry at: #context ifAbsent: [ '' ].
	suffix := entry at: #suffix ifAbsent: [ '' ].
	target := entry at: #target ifAbsent: [ entry at: #correct ifAbsent: [ '' ] ].
	^ prefix , '|||' , suffix , '|||' , target
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> filter: entries [
	"Apply all quality filters to the given collection of FIM entries.
	 Returns a new OrderedCollection with cleaned entries."

	| result |
	result := entries.
	result := self removeEmptyTargets: result.
	result := self removeShortTargets: result.
	result := self deduplicateExact: result.
	result := self deduplicateNear: result.
	preferTokenBoundary ifTrue: [
		result := self preferTokenBoundaryCuts: result ].
	result := self capPerMethod: result.
	^ result
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> filterAndAnnotate: entries [
	"Apply all quality filters and add metadata to surviving entries."

	| filtered |
	filtered := self filter: entries.
	filtered do: [ :entry | self addMetadataTo: entry ].
	^ filtered
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> initialize [

	super initialize.
	minTargetLength := 2.
	maxExamplesPerMethod := 5.
	nearDuplicateWindowSize := 50.
	preferTokenBoundary := true
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> isTokenBoundaryTarget: entry [
	"Return true if the target starts at a token boundary.
	 A target is at a token boundary when the prefix ends with whitespace,
	 punctuation, or is empty, OR when the target starts with an uppercase letter."

	| prefix target lastPrefixChar |
	prefix := entry at: #context ifAbsent: [ '' ].
	target := entry at: #target ifAbsent: [ entry at: #correct ifAbsent: [ '' ] ].
	prefix isEmpty ifTrue: [ ^ true ].
	target isEmpty ifTrue: [ ^ true ].
	lastPrefixChar := prefix last.
	(lastPrefixChar isSeparator or: [
		 lastPrefixChar isLetter not and: [ lastPrefixChar isDigit not ] ])
		ifTrue: [ ^ true ].
	target first isUppercase ifTrue: [ ^ true ].
	^ false
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> maxExamplesPerMethod [

	^ maxExamplesPerMethod
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> maxExamplesPerMethod: anInteger [

	maxExamplesPerMethod := anInteger
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> methodKeyFor: entry [
	"Extract a method identifier from the entry context.
	 Uses the first line of the prefix as a proxy for method identity."

	| prefix firstLine |
	prefix := entry at: #context ifAbsent: [ '' ].
	firstLine := (prefix lines ifEmpty: [ #('') ]) first.
	^ firstLine
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> minTargetLength [

	^ minTargetLength
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> minTargetLength: anInteger [

	minTargetLength := anInteger
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> nearDuplicateWindowSize [

	^ nearDuplicateWindowSize
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> nearDuplicateWindowSize: anInteger [

	nearDuplicateWindowSize := anInteger
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> nearKeyFor: entry [
	"Compute a near-duplicate key using trailing prefix window and leading suffix window."

	| prefix suffix prefixTail suffixHead |
	prefix := entry at: #context ifAbsent: [ '' ].
	suffix := entry at: #suffix ifAbsent: [ '' ].
	prefixTail := prefix size <= nearDuplicateWindowSize
		              ifTrue: [ prefix ]
		              ifFalse: [ prefix last: nearDuplicateWindowSize ].
	suffixHead := suffix size <= nearDuplicateWindowSize
		              ifTrue: [ suffix ]
		              ifFalse: [ suffix first: nearDuplicateWindowSize ].
	^ prefixTail , '|||' , suffixHead
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> preferTokenBoundary [

	^ preferTokenBoundary
]

{ #category : 'accessing' }
CooFimDataQualityFilter >> preferTokenBoundary: aBoolean [

	preferTokenBoundary := aBoolean
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> preferTokenBoundaryCuts: entries [
	"When multiple entries exist for the same region, prefer those where
	 the target starts at a token boundary (word start, after whitespace
	 or punctuation). Non-boundary entries are kept only if no boundary
	 alternative exists for the same near-key."

	| groups result |
	groups := Dictionary new.
	entries do: [ :entry |
		| key |
		key := self nearKeyFor: entry.
		(groups at: key ifAbsentPut: [ OrderedCollection new ]) add: entry ].
	result := OrderedCollection new.
	groups valuesDo: [ :group |
		| boundary |
		boundary := group select: [ :entry | self isTokenBoundaryTarget: entry ].
		boundary ifEmpty: [ result addAll: group ]
		         ifNotEmpty: [ result addAll: boundary ] ].
	^ result
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> removeEmptyTargets: entries [
	"Remove entries where the target is empty or nil."

	^ entries reject: [ :entry |
		  | target |
		  target := entry at: #target ifAbsent: [ entry at: #correct ifAbsent: [ '' ] ].
		  target isNil or: [ target isEmpty ] ]
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> removeShortTargets: entries [
	"Remove entries where the target is shorter than minTargetLength."

	^ entries select: [ :entry |
		  | target |
		  target := entry at: #target ifAbsent: [ entry at: #correct ifAbsent: [ '' ] ].
		  target size >= minTargetLength ]
]

{ #category : 'filtering' }
CooFimDataQualityFilter >> statisticsFor: entries [
	"Return a dictionary with statistics about the entry collection."

	| targets lengths |
	targets := entries collect: [ :e |
		e at: #target ifAbsent: [ e at: #correct ifAbsent: [ '' ] ] ].
	lengths := targets collect: [ :t | t size ].
	^ Dictionary new
		at: #totalEntries put: entries size;
		at: #emptyTargets put: (targets count: [ :t | t isEmpty ]);
		at: #meanTargetLength put: (lengths ifEmpty: [ 0 ] ifNotEmpty: [
			(lengths sum / lengths size) asFloat ]);
		at: #minTargetLength put: (lengths ifEmpty: [ 0 ] ifNotEmpty: [ lengths min ]);
		at: #maxTargetLength put: (lengths ifEmpty: [ 0 ] ifNotEmpty: [ lengths max ]);
		yourself
]
