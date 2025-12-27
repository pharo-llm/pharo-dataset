Class {
	#name : 'CooCompletionDatasetExporterTestMethodNode',
	#superclass : 'Object',
	#instVars : [
		'source'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterTestMethodNode class >> withSource: aString [

	^ self new
		source: aString;
		yourself
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMethodNode >> source [

	^ source
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestMethodNode >> source: aString [

	source := aString
]
