Class {
	#name : 'BaselineOfHeuristicCompletionGenerator',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfHeuristicCompletionGenerator',
	#package : 'BaselineOfHeuristicCompletionGenerator'
}

{ #category : 'baselines' }
BaselineOfHeuristicCompletionGenerator >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				baseline: 'ExtendedHeuristicCompletionBenchmarks'
				with: [ spec repository: 'github://omarabedelkader/HeuristicCompletion-Benchmarks/repository' ].

			spec package: 'HeuristicCompletion-Generator'.
			spec package: 'HeuristicCompletion-Generator-Tests' with: [ spec requires: #( 'HeuristicCompletion-Generator' ) ] ]
]
