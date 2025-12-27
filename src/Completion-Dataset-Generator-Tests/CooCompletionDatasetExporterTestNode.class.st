Class {
	#name : 'CooCompletionDatasetExporterTestNode',
	#superclass : 'Object',
	#instVars : [
		'methodNode',
		'sourceInterval',
		'printStringValue'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'accessing' }
CooCompletionDatasetExporterTestNode >> methodNode [

	^ methodNode
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestNode >> methodNode: aMethodNode [

	methodNode := aMethodNode
]

{ #category : 'printing' }
CooCompletionDatasetExporterTestNode >> printString [ 

	^ printStringValue ifNil: [ super printString ]
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestNode >> printStringValue: aString [

	printStringValue := aString
]

{ #category : 'printing' }
CooCompletionDatasetExporterTestNode >> sourceInterval [

	^ sourceInterval
]

{ #category : 'printing' }
CooCompletionDatasetExporterTestNode >> sourceInterval: anInterval [

	sourceInterval := anInterval
]
