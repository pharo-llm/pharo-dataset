Class {
	#name : 'CooCompletionDatasetExporterTest',
	#superclass : 'TestCase',
	#category : 'HeuristicCompletion-Generator-Tests',
	#package : 'HeuristicCompletion-Generator-Tests'
}

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testEntriesAsCompletionJsonlStringSerializesOneObjectPerLine [

	| exporter jsonl lines entry1 entry2 |
	exporter := CooCompletionDatasetExporter new.
	exporter
		recordContext: 'ctx1'
		candidates: {
				(CooCompletionDatasetExporterTestCandidate withContents: 'alpha' fetcherName: 'lexical').
				(CooCompletionDatasetExporterTestCandidate withContents: 'beta' fetcherName: 'type') }
		correct: 'answer1'.
	exporter
		recordContext: 'ctx2'
		candidates: {
				(CooCompletionDatasetExporterTestCandidate withContents: 'gamma' fetcherName: 'global') }
		correct: 'answer2'.

	jsonl := exporter entriesAsCompletionJsonlString.
	lines := jsonl lines.

	self assert: lines size equals: 2.
	entry1 := NeoJSONReader fromString: lines first.
	self assert: (entry1 at: 'context') equals: 'ctx1'.
	self assert: (entry1 at: 'correct') equals: 'answer1'.
	self assert: (entry1 at: 'candidates') asArray equals: #( 'alpha' 'beta' ).
	entry2 := NeoJSONReader fromString: lines second.
	self assert: (entry2 at: 'context') equals: 'ctx2'.
	self assert: (entry2 at: 'correct') equals: 'answer2'
]

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testEntriesAsInfillJsonlStringSerializesOneObjectPerLine [

	| exporter jsonl lines entry |
	exporter := CooCompletionDatasetExporter new.
	exporter outputFormat: #infill.
	exporter
		recordContext: 'prefix'
		suffix: 'suffix'
		target: 'tgt'
		candidates: {
				(CooCompletionDatasetExporterTestCandidate withContents: 'alpha' fetcherName: 'lexical') }
		correct: 'answer'.

	jsonl := exporter entriesAsInfillJsonlString.
	lines := jsonl lines.

	self assert: lines size equals: 1.
	entry := NeoJSONReader fromString: lines first.
	self assert: (entry at: 'prefix_code') equals: 'prefix'.
	self assert: (entry at: 'suffix_code') equals: 'suffix'.
	self assert: (entry at: 'target') equals: 'tgt'
]

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testEntriesAsJsonStringSerializesEntries [

	| exporter json data entry |
	exporter := CooCompletionDatasetExporter new.
	exporter
		recordContext: 'ctx'
		candidates: {
				(CooCompletionDatasetExporterTestCandidate withContents: 'alpha' fetcherName: 'lexical').
				(CooCompletionDatasetExporterTestCandidate withContents: 'beta' fetcherName: 'type') }
		correct: 'answer'.

	json := exporter entriesAsCompletionJsonString.
	data := NeoJSONReader fromString: json.

	self assert: data size equals: 1.
	entry := data first.
	self assert: (entry at: 'context') equals: 'ctx'.
	self assert: (entry at: 'correct') equals: 'answer'.
	self assert: (entry at: 'candidates') asArray equals: #( 'alpha' 'beta' ).
	self assert: (entry at: 'fetchers') asArray equals: #( 'lexical' 'type' )
]

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testEntriesAsJsonlStringDispatchesOnOutputFormat [

	| exporter completionJsonl infillJsonl |
	exporter := CooCompletionDatasetExporter new.
	exporter
		recordContext: 'ctx'
		candidates: {
				(CooCompletionDatasetExporterTestCandidate withContents: 'alpha' fetcherName: 'lexical') }
		correct: 'answer'.

	exporter outputFormat: #completion.
	completionJsonl := exporter entriesAsJsonlString.
	self assert: (completionJsonl includesSubstring: '"context"').

	exporter outputFormat: #infill.
	infillJsonl := exporter entriesAsJsonlString.
	self assert: (infillJsonl includesSubstring: '"prefix_code"')
]

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testExportOnPackagesValidatesPackagesExist [

	| tempFile |
	tempFile := FileSystem workingDirectory / 'tmp' / 'ai-sorter-tests'
	            / 'missing-package.json'.

	self
		should: [
			CooCompletionDatasetExporter
				exportOnPackages: #( 'No-Such-Package-For-Test' )
				heuristics: nil
				context: #none
				to: tempFile fullName ]
		raise: Error.
	self deny: tempFile exists
]
