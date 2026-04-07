"
Available contexts
- #completion:           	receiver expression and the requested prefix (completion-ctx-messages.json)
- #surroundingCompletion:	source up to the call site plus the requested prefix (completion-surrounding-ctx-messages.json)
- #lineCompletion:      	source line up to the call site plus the requested prefix (completion-surrounding-line-ctx-messages.json)
- #classCompletion:     	class header + surrounding source up to the call site plus the requested prefix
Available output formats
- #completion:  original format with context/candidates/fetchers/correct
- #infill:      FIM training format with prefix_code/suffix_code/target
- #reranker:    grouped candidate list with labels and baseline ranks
"
Class {
	#name : 'CooCompletionDatasetExporterMessages',
	#superclass : 'CooCompletionDatasetExporter',
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterMessages class >> exportAllMessagesInfillJsonl [

	<script>
	^ self
		  exportOnPackages: self defaultPackages1
		  heuristics: [ :builder | builder messagesHeuristic ]
		  context: #surroundingCompletion
		  outputFormat: #infill
		  toJsonl: 'infill-messages.jsonl'
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterMessages class >> exportAllMessagesRerankerJsonl [

	<script>
	^ self
		  exportOnPackages: self defaultPackages
		  heuristics: [ :builder | builder messageHeuristic ]
		  context: #surroundingCompletion
		  outputFormat: #reranker
		  toJsonl: 'reranker-messages.jsonl'
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> benchCallsite: aMessageNode inMethod: aMethod atPosition: aPosition [

	| originalSelector position source nodeEnd suffixCode target |
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


	{ (self maxPrefixSizeFor: originalSelector) } do: [ :index |
			| prefix completion candidates context |
			prefix := self extractPrefixFrom: originalSelector at: index.
			target := originalSelector copyFrom: index + 1 to: originalSelector size.
			aMessageNode selectorNode value: prefix.

			completion := self buildCompletionFor: aMessageNode atPosition: position.

			candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.

			context := self
				           contextFor: aMessageNode
				           inMethod: aMethod
				           atPosition: position
				           withPrefix: prefix.

			self
				recordContext: context
				suffix: suffixCode
				target: target
				candidates: candidates
				correct: originalSelector ].

	aMessageNode selectorNode value: originalSelector
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> buildCompletionFor: aMessageNode atPosition: aPosition [

	^ builder
		  node: aMessageNode;
		  completionContext: (CoBenchmarkContext new
				   callsite: aMessageNode;
				   position: aPosition;
				   yourself);
		  buildCompletion
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> completionContextFor: aMessageNode withPrefix: prefix [

	| receiver source |
	receiver := aMessageNode receiver.
	source := aMessageNode methodNode source.

	receiver ifNil: [ ^ prefix ].

	^ (self sourceForNode: receiver inMethodSource: source) trimBoth , ' '
	  , prefix
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> contextFor: aMessageNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [

	^ self contextStrategy
		  caseOf: {
				  ([ #completion ] -> [ self completionContextFor: aMessageNode withPrefix: prefix ]).
			([ #lineCompletion ] -> [
				   self lineCompletionContextFor: aMessageNode
					   atPosition: aPosition
					   withPrefix: prefix ]).
				  ([ #surroundingCompletion ]
				   -> [ self surroundingCompletionContextFor: aMessageNode atPosition: aPosition withPrefix: prefix ]).
				  ([ #classCompletion ]
				   -> [ self classCompletionContextFor: aMessageNode inMethod: aMethod atPosition: aPosition withPrefix: prefix ]) }
		  otherwise: [ self surroundingCompletionContextFor: aMessageNode atPosition: aPosition withPrefix: prefix ]
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> extractPrefixFrom: selector at: index [

	^ selector copyFrom: 1 to: index
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith:
		(CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> maxPrefixSizeFor: selector [

	^ selector size min: 8
]

{ #category : 'running' }
CooCompletionDatasetExporterMessages >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [
				self
					benchCallsite: node
					inMethod: method
					atPosition: node keywordsIntervals first ] ] ]
]
