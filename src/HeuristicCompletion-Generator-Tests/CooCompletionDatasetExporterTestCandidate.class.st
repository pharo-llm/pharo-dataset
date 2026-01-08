"
Mock
"
Class {
	#name : 'CooCompletionDatasetExporterTestCandidate',
	#superclass : 'Object',
	#instVars : [
		'contents',
		'fetcherName'
	],
	#category : 'HeuristicCompletion-Generator-Tests',
	#package : 'HeuristicCompletion-Generator-Tests'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterTestCandidate class >> withContents: aString [

	^ self new
		  contents: aString;
		  yourself
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterTestCandidate class >> withContents: aString fetcherName: aFetcherName [

	^ self new
		  contents: aString;
		  fetcherName: aFetcherName;
		  yourself
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> contents [

	^ contents
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> contents: aString [

	contents := aString
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> fetcherName [

	^ fetcherName
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> fetcherName: aString [

	fetcherName := aString
]
