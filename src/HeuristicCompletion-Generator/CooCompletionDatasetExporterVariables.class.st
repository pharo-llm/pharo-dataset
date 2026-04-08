"
Available contexts
- #completion:           	receiver expression and the requested prefix (completion-ctx-variables.json)
- #surroundingCompletion:	source up to the call site plus the requested prefix (completion-surrounding-ctx-variables.json)
- #classCompletion:     	class header + surrounding source up to the call site plus the requested prefix
Available output formats
- #completion:  original format with context/candidates/fetchers/correct
- #infill:      FIM training format with prefix_code/suffix_code/target
- #reranker:    grouped candidate list with labels and baseline ranks
"
Class {
	#name : 'CooCompletionDatasetExporterVariables',
	#superclass : 'CooCompletionDatasetExporter',
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'runner' }
CooCompletionDatasetExporterVariables class >> exportAllVariablesInfillFilteredJsonl [

	<script>
	^ self
		  exportOnPackages: self defaultPackages1
		  heuristics: [ :builder | builder variablesHeuristic ]
		  context: #surroundingCompletion
		  outputFormat: #infill
		  qualityFilter: CooFimDataQualityFilter default
		  toJsonl: 'infill-variables-filtered.jsonl'
]

{ #category : 'runner' }
CooCompletionDatasetExporterVariables class >> exportAllVariablesInfillJsonl [

	<script>
	^ self
		  exportOnPackages: self defaultPackages1
		  heuristics: [ :builder | builder variablesHeuristic ]
		  context: #surroundingCompletion
		  outputFormat: #infill
		  toJsonl: 'infill-variables.jsonl'
]

{ #category : 'runner' }
CooCompletionDatasetExporterVariables class >> exportAllVariablesRerankerJsonl [

	<script>
	^ self
		  exportOnPackages: self defaultPackages1
		  heuristics: [ :builder | builder variablesHeuristic ]
		  context: #surroundingCompletion
		  outputFormat: #reranker
		  toJsonl: 'reranker-variables.jsonl'
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> benchCallsite: aVariableNode inMethod: aMethod atPosition: aPosition [

	| originalName position source nodeEnd suffixCode target |
	originalName := aVariableNode name.
	position := (aPosition respondsTo: #first)
		            ifTrue: [ aPosition first ]
		            ifFalse: [ aPosition ].


	source := aVariableNode methodNode source.
	nodeEnd := position + originalName size - 1.
	suffixCode := nodeEnd < source size
		              ifTrue: [ source copyFrom: nodeEnd + 1 to: source size ]
		              ifFalse: [ '' ].

	{ (self maxPrefixSizeFor: aVariableNode) } do: [ :index |
			| prefix completion candidates context |
			prefix := self extractPrefixFrom: originalName at: index.
			target := originalName copyFrom: index + 1 to: originalName size.
			aVariableNode name: prefix.

			completion := self buildCompletionFor: aVariableNode atPosition: position.

			candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.

			context := self
				           contextFor: aVariableNode
				           inMethod: aMethod
				           atPosition: position
				           withPrefix: prefix.

			self
				recordContext: context
				suffix: suffixCode
				target: target
				candidates: candidates
				correct: originalName ].

	aVariableNode name: originalName
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> buildCompletionFor: aVariableNode atPosition: aPosition [

	^ builder
		  node: aVariableNode;
		  completionContext: (CoBenchmarkVariableContext new
				   callsite: aVariableNode;
				   position: aPosition;
				   yourself);
		  buildCompletion
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> completionContextFor: aVariableNode withPrefix: prefix [

	^ prefix
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> contextFor: aVariableNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [

	^ self contextStrategy
		  caseOf: {
				  ([ #completion ] -> [ self completionContextFor: aVariableNode withPrefix: prefix ]).
				  ([ #lineCompletion ] -> [ self lineCompletionContextFor: aVariableNode atPosition: aPosition withPrefix: prefix ]).
				  ([ #surroundingCompletion ]
				     -> [ self surroundingCompletionContextFor: aVariableNode atPosition: aPosition withPrefix: prefix ]).
				  ([ #classCompletion ]
				   -> [ self classCompletionContextFor: aVariableNode inMethod: aMethod atPosition: aPosition withPrefix: prefix ]) }
		  otherwise: [ self surroundingCompletionContextFor: aVariableNode atPosition: aPosition withPrefix: prefix ]
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> extractPrefixFrom: variable at: index [

	^ variable copyFrom: 1 to: index
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith:
		(CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterVariables >> maxPrefixSizeFor: aVariableNode [

	^ aVariableNode name size min: 8
]

{ #category : 'running' }
CooCompletionDatasetExporterVariables >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isVariable and: [ node name first isUppercase ]) ifTrue: [
				self
					benchCallsite: node
					inMethod: method
					atPosition: node start ] ] ]
]
