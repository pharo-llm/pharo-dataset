Class {
	#name : 'CooCompletionDatasetExporterVariablesTest',
	#superclass : 'TestCase',
	#category : 'HeuristicCompletion-Generator-Tests',
	#package : 'HeuristicCompletion-Generator-Tests'
}

{ #category : 'tests' }
CooCompletionDatasetExporterVariablesTest >> testExtractPrefixFromAtIndex [

	| exporter |
	exporter := CooCompletionDatasetExporterVariables new.

	self
		assert: (exporter extractPrefixFrom: 'VariableName' at: 3)
		equals: 'Var'
]

{ #category : 'tests' }
CooCompletionDatasetExporterVariablesTest >> testMaxPrefixSizeForLimitsToEight [

	| exporter node |
	exporter := CooCompletionDatasetExporterVariables new.
	node := CooCompletionDatasetExporterTestVariableNode named: 'LongVariableName'.

	self assert: (exporter maxPrefixSizeFor: node) equals: 8
]
