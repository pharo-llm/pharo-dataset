Class {
	#name : 'CooCompletionDatasetExporterTestMessageNode',
	#superclass : 'Object',
	#instVars : [
		'receiver',
		'methodNode',
		'selector'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> methodNode [

	^ methodNode
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> methodNode: aMethodNode [

	methodNode := aMethodNode
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> receiver [

	^ receiver
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> receiver: aReceiver [

	receiver := aReceiver
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> selector [

	^ selector
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMessageNode >> selector: aSelector [

	selector := aSelector
]
