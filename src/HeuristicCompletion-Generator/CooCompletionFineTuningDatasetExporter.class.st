"
I export fine-tuning datasets for code completion benchmarks.

This single class handles both message and variable callsites, collects
entries for both kinds into one dataset, and serializes them to JSONL.

Package/category are intentionally kept unchanged.
"
Class {
	#name : 'CooCompletionFineTuningDatasetExporter',
	#superclass : 'CooStaticBenchmarks',
	#instVars : [
		'entries',
		'contextStrategy',
		'outputFormat',
		'qualityFilter'
	],
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> configureMessageHeuristicsOn: aBuilder [

	(aBuilder respondsTo: #messagesHeuristic)
		ifTrue: [ ^ aBuilder messagesHeuristic ].
	(aBuilder respondsTo: #messageHeuristic)
		ifTrue: [ ^ aBuilder messageHeuristic ].
	self error: 'No message heuristic selector found on builder'
]

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> defaultPackages [

	^ CooCompletionDatasetExporter defaultPackages
]

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> defaultPackages1 [

	^ CooCompletionDatasetExporter defaultPackages1
]

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> exportAllFIMJsonl [

	<script>
	^ self
		exportOnPackages: self defaultPackages1
		context: #surroundingCompletion
		outputFormat: #fim
		qualityFilter: CooFimDataQualityFilter default
		toJsonl: 'fim-messages-and-variables.jsonl'
]

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> exportAllRerankerJsonl [

	<script>
	^ self
		exportOnPackages: self defaultPackages1
		context: #surroundingCompletion
		outputFormat: #reranker
		qualityFilter: nil
		toJsonl: 'reranker-messages-and-variables.jsonl'
]

{ #category : 'as yet unclassified' }
CooCompletionFineTuningDatasetExporter class >> exportOnPackages: aCollectionOfPackages context: aContextStrategy outputFormat: anOutputFormat qualityFilter: aFilter toJsonl: aPathString [

	| exporter |
	exporter := self new
		builder: CoASTHeuristicsResultSetBuilder new;
		contextStrategy: aContextStrategy;
		outputFormat: anOutputFormat;
		qualityFilter: aFilter;
		yourself.

	aCollectionOfPackages do: [ :packageOrName |
		| package |
		package := packageOrName isString
			ifTrue: [ PackageOrganizer default packageNamed: packageOrName ]
			ifFalse: [ packageOrName ].
		package ifNil: [ self error: 'Package not found: ' , packageOrName printString ].
		exporter scope: (CoBenchmarkPackage on: package).
		exporter run ].

	exporter applyQualityFilterIfNeeded.
	aPathString ifNotNil: [ exporter writeToFileNamedAsJsonl: aPathString ].
	^ exporter
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> applyQualityFilterIfNeeded [

	qualityFilter ifNotNil: [ entries := qualityFilter filterAndAnnotate: entries ]
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> benchMessageCallsite: aMessageNode inMethod: aMethod atPosition: aPosition [

	| originalSelector position source nodeEnd suffixCode |
	originalSelector := aMessageNode selectorNode value.
	position := (aPosition respondsTo: #first)
		ifTrue: [ aPosition first ]
		ifFalse: [ aPosition ].

	source := aMessageNode methodNode source.
	nodeEnd := (aPosition respondsTo: #last)
		ifTrue: [ aPosition last ]
		ifFalse: [ position + originalSelector size - 1 ].
	suffixCode := nodeEnd < source size
		ifTrue: [ source copyFrom: nodeEnd + 1 to: source size ]
		ifFalse: [ '' ].

	{ (self maxPrefixSizeForText: originalSelector) } do: [ :index |
		| prefix target completion candidates context metadata |
		prefix := self extractPrefixFromText: originalSelector at: index.
		target := originalSelector copyFrom: index + 1 to: originalSelector size.
		aMessageNode selectorNode value: prefix.
		completion := self buildMessageCompletionFor: aMessageNode atPosition: position.
		candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.
		context := self contextFor: aMessageNode inMethod: aMethod atPosition: position withPrefix: prefix.
		metadata := self messageMetadataFor: aMessageNode inMethod: aMethod prefix: prefix.
		self
			recordContext: context
			suffix: suffixCode
			target: target
			candidates: candidates
			correct: originalSelector
			metadata: metadata ].

	aMessageNode selectorNode value: originalSelector
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> benchVariableCallsite: aVariableNode inMethod: aMethod atPosition: aPosition [

	| originalName position source nodeEnd suffixCode |
	originalName := aVariableNode name.
	position := (aPosition respondsTo: #first)
		ifTrue: [ aPosition first ]
		ifFalse: [ aPosition ].

	source := aVariableNode methodNode source.
	nodeEnd := position + originalName size - 1.
	suffixCode := nodeEnd < source size
		ifTrue: [ source copyFrom: nodeEnd + 1 to: source size ]
		ifFalse: [ '' ].

	{ (self maxPrefixSizeForText: originalName) } do: [ :index |
		| prefix target completion candidates context metadata |
		prefix := self extractPrefixFromText: originalName at: index.
		target := originalName copyFrom: index + 1 to: originalName size.
		aVariableNode name: prefix.
		completion := self buildVariableCompletionFor: aVariableNode atPosition: position.
		candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.
		context := self contextFor: aVariableNode inMethod: aMethod atPosition: position withPrefix: prefix.
		metadata := self variableMetadataFor: aVariableNode inMethod: aMethod prefix: prefix.
		self
			recordContext: context
			suffix: suffixCode
			target: target
			candidates: candidates
			correct: originalName
			metadata: metadata ].

	aVariableNode name: originalName
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> buildMessageCompletionFor: aMessageNode atPosition: aPosition [

	self class configureMessageHeuristicsOn: builder.
	^ builder
		node: aMessageNode;
		completionContext: (CoBenchmarkContext new
			callsite: aMessageNode;
			position: aPosition;
			yourself);
		buildCompletion
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> buildVariableCompletionFor: aVariableNode atPosition: aPosition [

	builder variablesHeuristic.
	^ builder
		node: aVariableNode;
		completionContext: (CoBenchmarkVariableContext new
			callsite: aVariableNode;
			position: aPosition;
			yourself);
		buildCompletion
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> candidateDictionariesFor: entry [

	| correct candidateTexts fetchers candidates correctFound |
	correct := entry at: #correct.
	candidateTexts := entry at: #candidates ifAbsent: [ #() ].
	fetchers := entry at: #fetchers ifAbsent: [ #() ].
	correctFound := false.
	candidates := candidateTexts withIndex collect: [ :text :rank |
		| isCorrect |
		isCorrect := text = correct.
		isCorrect ifTrue: [ correctFound := true ].
		Dictionary new
			at: 'text' put: text;
			at: 'fetcher' put: (fetchers at: rank ifAbsent: [ '' ]);
			at: 'baseline_rank' put: rank;
			at: 'label' put: (isCorrect ifTrue: [ 1 ] ifFalse: [ 0 ]);
			yourself ].
	correctFound ifFalse: [
		candidates := candidates copyWith: (Dictionary new
			at: 'text' put: correct;
			at: 'fetcher' put: '';
			at: 'baseline_rank' put: candidates size + 1;
			at: 'label' put: 1;
			yourself) ].
	^ candidates
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> classCompletionContextFor: aNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [

	| classHeader methodContext |
	classHeader := self classHeaderFor: aMethod.
	methodContext := self surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix.
	classHeader isEmpty ifTrue: [ ^ methodContext ].
	^ classHeader , String cr , String cr , methodContext
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> classHeaderFor: aMethod [

	| class |
	(aMethod isNil or: [ (aMethod respondsTo: #methodClass) not ]) ifTrue: [ ^ '' ].
	class := aMethod methodClass.
	class ifNil: [ ^ '' ].
	^ String streamContents: [ :stream |
		stream
			nextPutAll: class superclass name;
			nextPutAll: ' subclass: #';
			nextPutAll: class name;
			cr;
			nextPutAll: 'instanceVariableNames: ''';
			nextPutAll: (' ' join: class instVarNames);
			nextPut: $';
			cr;
			nextPutAll: 'classVariableNames: ''';
			nextPutAll: (' ' join: class classVarNames);
			nextPut: $' ]
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> completionContextFor: aNode withPrefix: prefix [

	aNode isMessage ifTrue: [ ^ self messageCompletionContextFor: aNode withPrefix: prefix ].
	^ self variableCompletionContextFor: aNode withPrefix: prefix
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> contextFor: aNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [

	^ self contextStrategy
		caseOf: {
			([ #completion ] -> [ self completionContextFor: aNode withPrefix: prefix ]).
			([ #lineCompletion ] -> [ self lineCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix ]).
			([ #surroundingCompletion ] -> [ self surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix ]).
			([ #classCompletion ] -> [ self classCompletionContextFor: aNode inMethod: aMethod atPosition: aPosition withPrefix: prefix ]) }
		otherwise: [ self surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix ]
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> contextStrategy [

	^ contextStrategy
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> contextStrategy: aSymbol [

	contextStrategy := aSymbol
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> entries [

	^ entries
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> entriesAsFimJsonlString [

	^ String cr join: (entries collect: [ :entry |
		NeoJSONWriter toString: (Dictionary new
			at: 'prompt' put: (self fimPromptFor: entry);
			at: 'completion' put: (entry at: #target ifAbsent: [ entry at: #correct ]);
			at: 'prefix_code' put: (entry at: #context);
			at: 'suffix_code' put: (entry at: #suffix ifAbsent: [ '' ]);
			at: 'target' put: (entry at: #target ifAbsent: [ entry at: #correct ]);
			at: 'language' put: 'Smalltalk';
			at: 'completion_kind' put: (entry at: #completionKind ifAbsent: [ 'unknown' ]);
			at: 'receiver_type' put: (entry at: #receiverType ifAbsent: [ '' ]);
			at: 'prefix' put: (entry at: #prefix ifAbsent: [ '' ]);
			yourself) ])
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> entriesAsJsonlString [

	^ self entriesAsFimJsonlString
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> entriesAsRerankerJsonlString [

	^ String cr join: (entries collect: [ :entry |
				   | positive negatives |
				   positive := entry at: #correct.
				   negatives := self negativeCandidatesFor: entry excluding: positive.
				   NeoJSONWriter toString: (Dictionary new
						    at: 'query' put: (self rerankerQueryFor: entry);
						    at: 'positive' put: (Array with: positive);
						    at: 'negative' put: negatives;
						    at: 'context_before' put: (entry at: #context);
						    at: 'context_after' put: (entry at: #suffix ifAbsent: [ '' ]);
						    at: 'language' put: 'Smalltalk';
						    at: 'completion_kind' put: (entry at: #completionKind ifAbsent: [ 'unknown' ]);
						    at: 'receiver_type' put: (entry at: #receiverType ifAbsent: [ '' ]);
						    at: 'prefix' put: (entry at: #prefix ifAbsent: [ '' ]);
						    at: 'gold_text' put: positive;
						    at: 'correct' put: positive;
						    at: 'candidates' put: (self candidateDictionariesFor: entry);
						    yourself) ])
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> extractPrefixFromText: aString at: index [

	^ aString copyFrom: 1 to: index
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith: (CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> fimPromptFor: entry [

	^ String streamContents: [ :stream |
		stream
			nextPutAll: '<|fim_prefix|>';
			nextPutAll: (entry at: #context);
			nextPutAll: '<|fim_suffix|>';
			nextPutAll: (entry at: #suffix ifAbsent: [ '' ]);
			nextPutAll: '<|fim_middle|>' ]
]

{ #category : 'initialization' }
CooCompletionFineTuningDatasetExporter >> initialize [

	super initialize.
	entries := OrderedCollection new.
	outputFormat := #fim.
	contextStrategy := #surroundingCompletion.
	qualityFilter := nil
]

{ #category : 'Protocol (as yet unclassified) - 4 selector(s)' }
CooCompletionFineTuningDatasetExporter >> lineCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [

	| source position endIndex lineStart linePrefix |
	source := aNode methodNode source.
	position := (aPosition respondsTo: #first)
		ifTrue: [ aPosition first ]
		ifFalse: [ aPosition ].
	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.
	lineStart := endIndex.
	[ lineStart > 0 and: [ | current | current := source at: lineStart. (current ~= Character lf) and: [ current ~= Character cr ] ] ]
		whileTrue: [ lineStart := lineStart - 1 ].
	lineStart := lineStart + 1.
	linePrefix := endIndex < lineStart ifTrue: [ '' ] ifFalse: [ source copyFrom: lineStart to: endIndex ].
	^ linePrefix , prefix
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> maxPrefixSizeForText: aString [

	^ aString size min: 8
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> messageCompletionContextFor: aMessageNode withPrefix: prefix [

	| receiver source |
	receiver := aMessageNode receiver.
	source := aMessageNode methodNode source.
	receiver ifNil: [ ^ prefix ].
	^ (self sourceForNode: receiver inMethodSource: source) trimBoth , ' ' , prefix
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> messageMetadataFor: aMessageNode inMethod: aMethod prefix: prefix [

	^ Dictionary new
		at: #completionKind put: 'message';
		at: #receiverType put: (self receiverTypeFor: aMessageNode inMethod: aMethod);
		at: #prefix put: prefix;
		yourself
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> negativeCandidatesFor: entry excluding: positiveText [

	| seen negatives |
	seen := Set with: positiveText.
	negatives := OrderedCollection new.
	(entry at: #candidates ifAbsent: [ #() ]) do: [ :candidate |
		(seen includes: candidate) ifFalse: [
			seen add: candidate.
			negatives add: candidate ] ].
	^ negatives asArray
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> outputFormat [

	^ outputFormat
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> outputFormat: aSymbol [

	outputFormat := aSymbol
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> qualityFilter [

	^ qualityFilter
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> qualityFilter: anObject [

	qualityFilter := anObject
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> receiverTypeFor: aMessageNode inMethod: aMethod [

	| receiver binding |
	receiver := aMessageNode receiver.
	receiver ifNil: [ ^ '' ].
	((receiver respondsTo: #isSelfVariable) and: [ receiver isSelfVariable ]) ifTrue: [
		^ aMethod methodClass ifNil: [ '' ] ifNotNil: [ aMethod methodClass name ] ].
	((receiver respondsTo: #isSuperVariable) and: [ receiver isSuperVariable ]) ifTrue: [
		^ aMethod methodClass ifNil: [ '' ] ifNotNil: [ aMethod methodClass superclass ifNil: [ '' ] ifNotNil: [ aMethod methodClass superclass name ] ] ].
	((receiver respondsTo: #isLiteralNode) and: [ receiver isLiteralNode ]) ifTrue: [ ^ receiver value class name ].
	(receiver respondsTo: #binding) ifTrue: [ binding := receiver binding. binding ifNotNil: [ (binding respondsTo: #name) ifTrue: [ ^ binding name asString ] ] ].
	(receiver respondsTo: #name) ifTrue: [ ^ receiver name asString ].
	^ ''
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> recordCandidateInfoFor: aCandidate [

	| fetcherName fetcher |
	fetcherName := ''.
	(aCandidate respondsTo: #fetcher) ifTrue: [
		fetcher := aCandidate fetcher.
		fetcherName := (fetcher respondsTo: #name) ifTrue: [ fetcher name ] ifFalse: [ fetcher printString ] ].
	(aCandidate respondsTo: #fetcherName) ifTrue: [ fetcherName := aCandidate fetcherName ].
	^ fetcherName
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> recordContext: context suffix: suffixCode target: target candidates: candidates correct: originalValue metadata: metadataDictionary [

	| entry |
	entry := Dictionary new
		at: #context put: context;
		at: #suffix put: suffixCode;
		at: #target put: target;
		at: #candidates put: (candidates collect: [ :each | each contents ]);
		at: #fetchers put: (candidates collect: [ :each | self recordCandidateInfoFor: each ]);
		at: #correct put: originalValue;
		yourself.
	metadataDictionary keysAndValuesDo: [ :key :value | entry at: key put: value ].
	entries add: entry
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> rerankerQueryFor: entry [

	^ String streamContents: [ :stream |
		stream
			nextPutAll: (entry at: #context);
			nextPutAll: '<|candidate_slot|>';
			nextPutAll: (entry at: #suffix ifAbsent: [ '' ]) ]
]

{ #category : 'running' }
CooCompletionFineTuningDatasetExporter >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [ self benchMessageCallsite: node inMethod: method atPosition: node keywordsIntervals first ].
			(node isVariable and: [ node name notEmpty and: [ node name first isUppercase ] ]) ifTrue: [ self benchVariableCallsite: node inMethod: method atPosition: node start ] ] ]
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> sourceForNode: aNode inMethodSource: source [

	| interval |
	(aNode isNil or: [ source isNil ]) ifTrue: [ ^ '' ].
	interval := (aNode respondsTo: #sourceInterval) ifTrue: [ aNode sourceInterval ] ifFalse: [ nil ].
	(interval notNil and: [ interval size >= 2 ]) ifTrue: [ ^ source copyFrom: interval first to: interval last ].
	^ aNode printString
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [

	| source position endIndex prefixContext |
	source := aNode methodNode source.
	position := (aPosition respondsTo: #first) ifTrue: [ aPosition first ] ifFalse: [ aPosition ].
	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.
	prefixContext := endIndex < 1 ifTrue: [ '' ] ifFalse: [ source copyFrom: 1 to: endIndex ].
	^ prefixContext , prefix
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> variableCompletionContextFor: aVariableNode withPrefix: prefix [

	^ prefix
]

{ #category : 'benchmarks' }
CooCompletionFineTuningDatasetExporter >> variableMetadataFor: aVariableNode inMethod: aMethod prefix: prefix [

	^ Dictionary new
		at: #completionKind put: 'variable';
		at: #receiverType put: '';
		at: #prefix put: prefix;
		yourself
]

{ #category : 'accessing' }
CooCompletionFineTuningDatasetExporter >> writeToFileNamedAsJsonl: aString [

	| reference |
	reference := aString asFileReference.
	reference parent ensureCreateDirectory.
	reference writeStreamDo: [ :stream |
		stream truncate; nextPutAll: self entriesAsJsonlString ]
]
