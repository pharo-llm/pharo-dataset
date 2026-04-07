"
I manage dataset export runs for code completion benchmarks.

	Subclasses define how to build completion contexts and candidates for a
	specific callsite type (e.g. messages or variables). Instances collect
	entries with the completion context, candidate list, and correct answer,
	then serialize the results to JSON for storage on disk
"
Class {
	#name : 'CooCompletionDatasetExporter',
	#superclass : 'CooStaticBenchmarks',
	#instVars : [
		'entries',
		'contextStrategy',
		'outputFormat'
	],
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter class >> defaultPackages [

	^ #( 'Iceberg' 'Iceberg-ArchitecturalRules' 'Iceberg-Libgit' 'Iceberg-Libgit-Filetree' 'Iceberg-Libgit-Tonel'
	     'Iceberg-Memory' 'Iceberg-Metacello-Integration' 'Iceberg-Playground-Plugin-Gist' 'Iceberg-Plugin' 'Iceberg-Plugin-Github'
	     'Iceberg-Plugin-Metacello' 'Iceberg-Plugin-Migration' 'Iceberg-Plugin-Pharo' 'Iceberg-TipUI' 'Iceberg-TipUI-SnapShotBrowser'
	     'Iceberg-Plugin-Migration-Tests' 'Iceberg-Tests' 'Iceberg-Tests-MetacelloIntegration' 'Iceberg-TipUI-SnapshotBrowser-Tests'
	     'Iceberg-UI-Tests' 'Roassal' 'Roassal-Animation' 'Roassal-BaselineMap' 'Roassal-Builders' 'Roassal-Chart' 'Roassal-Chart-Examples'
	     'Roassal-Class-Examples' 'Roassal-Colors' 'Roassal-DSM' 'Roassal-Event' 'Roassal-Examples' 'Roassal-Experimental'
	     'Roassal-Exporters' 'Roassal-Exporters-Examples' 'Roassal-FlameGraph-Examples' 'Roassal-Inspector' 'Roassal-Interaction'
	     'Roassal-LayoutStudio' 'Roassal-Layouts' 'Roassal-Layouts-Util' 'Roassal-Legend' 'Roassal-Legend-Examples'
	     'Roassal-Menu' 'Roassal-Mondrian' 'Roassal-Pie' 'Roassal-Pie-Examples' 'Roassal-SVG' 'Roassal-SVG-Examples'
	     'Roassal-Shapes' 'Roassal-Spec' 'Roassal-Spec-Examples' 'Roassal-Spec-Morphic' 'Roassal-Sunburst' 'Roassal-Sunburst-Examples'
	     'Roassal-TreeMap' 'Roassal-TreeMap-Examples' 'Roassal-UML' 'Roassal-UML-Calypso' 'Roassal-UML-Examples'
	     'Roassal-Animation-Tests' 'Roassal-BaselineMap-Tests' 'Roassal-Chart-Tests' 'Roassal-Exporters-Tests'
	     'Roassal-Global-Tests' 'Roassal-Inspector-Tests' 'Roassal-Interaction-Tests' 'Roassal-LayoutStudio-Tests'
	     'Roassal-Layouts-Tests' 'Roassal-Shapes-Tests' 'Roassal-Spec-Tests' 'Roassal-SVG-Tests' 'Roassal-UML-Tests'
	     'Seaside-Ajaxifier-Core' 'Seaside-Canvas' 'Seaside-Component' 'Seaside-Continuation' 'Seaside-Core' 'Seaside-Development'
	     'Seaside-Email' 'Seaside-Environment' 'Seaside-Examples' 'Seaside-Flow' 'Seaside-JSON-Core' 'Seaside-Pharo-Canvas'
	     'Seaside-Pharo-Continuation' 'Seaside-Pharo-Core' 'Seaside-Pharo-Development' 'Seaside-Pharo-Email' 'Seaside-Pharo-Environment'
	     'Seaside-Pharo-Flow' 'Seaside-Pharo-JSON-Core' 'Seaside-Pharo-Tools-Web' 'Seaside-Pharo-Welcome' 'Seaside-REST-Core'
	     'Seaside-RenderLoop' 'Seaside-Session' 'Seaside-Tools-Core' 'Seaside-Tools-Web' 'Seaside-Welcome' 'Seaside-Widgets'
	     'Seaside-Zinc-Core' 'Seaside-Zinc-Pharo' 'Seaside-Tests-Canvas' 'Seaside-Tests-Component' 'Seaside-Tests-Core'
	     'Seaside-Tests-Environment' 'Seaside-Tests-Flow' 'Seaside-Tests-Functional' 'Seaside-Tests-Pharo-Canvas'
	     'Seaside-Tests-Pharo-Continuation' 'Seaside-Tests-Pharo-Core' 'Seaside-Tests-Pharo-Functional'
	     'Seaside-Tests-RenderLoop' 'Seaside-Tests-Session' 'Spec2-Adapters-Morphic' 'Spec2-Adapters-Morphic-ListView'
	     'Spec2-Adapters-Stub' 'Spec2-Code' 'Spec2-Code-Commands' 'Spec2-Code-Diff' 'Spec2-Code-Diff-Morphic'
	     'Spec2-Code-Morphic' 'Spec2-CommandLine' 'Spec2-Commander2' 'Spec2-Commands' 'Spec2-CommonWidgets' 'Spec2-Core'
	     'Spec2-Dialogs' 'Spec2-Examples' 'Spec2-Interactions' 'Spec2-Layout' 'Spec2-ListView' 'Spec2-Microdown' 'Spec2-Morphic'
	     'Spec2-Morphic-Examples' 'Spec2-Transmission' 'Spec2-Adapters-Morphic-Tests' 'Spec2-Backend-Tests' 'Spec2-Code-Backend-Tests'
	     'Spec2-Code-Diff-Tests' 'Spec2-Code-Tests' 'Spec2-Commander2-Tests' 'Spec2-Dialogs-Tests' 'Spec2-Morphic-Backend-Tests'
	     'Spec2-Morphic-Tests' 'Spec2-Tests' 'Moose-Blueprint-Invocations-Models' 'Moose-Blueprint-Models' 'Moose-Blueprint-Visualization-Models'
	     'Moose-Configuration' 'Moose-Core' 'Moose-Core-Generator' 'Moose-Importers' 'Moose-Query' 'Moose-Query-Extensions'
	     'Moose-SmalltalkImporter' 'MooseIDE-WelcomeBrowser' 'MooseIDE-Analysis' 'MooseIDE-AttributedText'
	     'MooseIDE-ButterflyMap' 'MooseIDE-ClassBlueprint' 'MooseIDE-CoUsageMap' 'MooseIDE-Core' 'MooseIDE-Core-Reporter'
	     'MooseIDE-CriticBrowser' 'MooseIDE-Dependency' 'MooseIDE-Duplication' 'MooseIDE-Export' 'MooseIDE-Famix' 'MooseIDE-LayerVisualization'
	     'MooseIDE-Meta' 'MooseIDE-NewTools' 'MooseIDE-QueriesBrowser' 'MooseIDE-QueriesDashboard' 'MooseIDE-Spotter'
	     'MooseIDE-Tagging' 'MooseIDE-Visualization' 'Moose-Blueprint-Models-Tests' 'Moose-Core-Tests' 'Moose-Core-Tests-Entities'
	     'Moose-Importers-Tests' 'Moose-Query-Test' 'Moose-SmalltalkImporter-Core-Tests' 'Moose-SmalltalkImporter-KGB-Tests'
	     'Moose-SmalltalkImporter-LAN-Tests' 'Moose-TestResources-KGB-P10InteractedReferee'
	     'Moose-TestResources-KGB-P11FullReferee' 'Moose-TestResources-KGB-P12FullReferencer'
	     'Moose-TestResources-KGB-P13FullReferencer' 'Moose-TestResources-KGB-P14FullReferee'
	     'Moose-TestResources-KGB-P1FullReferencer' 'Moose-TestResources-KGB-P2InteractedReferencerReferee'
	     'Moose-TestResources-KGB-P3InteractedReferencer' 'Moose-TestResources-KGB-P4FullInteracted'
	     'Moose-TestResources-KGB-P5FullReferee' 'Moose-TestResources-KGB-P6InteractedReferee'
	     'Moose-TestResources-KGB-P7ReferencerReferee' 'Moose-TestResources-KGB-P8FullReferencer'
	     'Moose-TestResources-KGB-P9FullReferencer' 'Moose-TestResources-KGB-PExtensions' 'Moose-TestResources-LAN'
	     'Moose-TestResources-LCOM' 'Moose-TestResources-PackageBlueprint-P1' 'Moose-TestResources-PackageBlueprint-P2'
	     'Moose-TestResources-PackageBlueprint-P3' 'Moose-TestResources-PackageBlueprint-P4'
	     'Moose-TestResources-Reference-Core' 'Moose-TestResources-Reference-External' 'Moose-TestResources-Reference-PackageOne'
	     'Moose-TestResources-Reference-PackageTwo' 'MooseIDE-ButterflyMap-Tests' 'MooseIDE-CoUsageMap-Tests'
	     'MooseIDE-CriticBrowser-Tests' 'MooseIDE-NewTools-Tests' 'MooseIDE-QueriesBrowser-Tests' 'MooseIDE-Spotter-Tests'
	     'MooseIDE-Tagging-Tests' 'MooseIDE-Tests' )
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter class >> defaultPackages1 [

	^ #( 'NECompletion' )
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter class >> exportOnPackages: aCollectionOfPackages heuristics: aHeuristicsBlock context: aContextStrategy outputFormat: anOutputFormat toJsonl: aPathString [

	| exporter |
	exporter := self new
		            builder: CoASTHeuristicsResultSetBuilder new;
		            contextStrategy: aContextStrategy;
		            outputFormat: anOutputFormat;
		            yourself.

	aHeuristicsBlock ifNotNil: [ aHeuristicsBlock value: exporter builder ].
	aCollectionOfPackages do: [ :packageOrName |
		| package |
		package := packageOrName isString
			           ifTrue: [ PackageOrganizer default packageNamed: packageOrName ]
			           ifFalse: [ packageOrName ].
		package ifNil: [ ^ self error: 'Package not found: ' , packageOrName printString ].
		exporter scope: (CoBenchmarkPackage on: package).
		exporter run ].
	exporter writeToFileNamedAsJsonl: aPathString.
	^ exporter
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporter >> benchCallsite: aMessageNode inMethod: aMethod atPosition: aPosition [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> classCompletionContextFor: aNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [

	| classHeader methodContext |
	classHeader := self classHeaderFor: aMethod.
	methodContext := self surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix.
	classHeader isEmpty ifTrue: [ ^ methodContext ].
	^ classHeader , String cr , String cr , methodContext
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> classHeaderFor: aMethod [

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
			  nextPutAll: '	instanceVariableNames: ''';
			  nextPutAll: (' ' join: class instVarNames);
			  nextPut: $';
			  cr;
			  nextPutAll: '	classVariableNames: ''';
			  nextPutAll: (' ' join: class classVarNames);
			  nextPut: $' ]
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporter >> completionContextFor: aMessageNode withPrefix: prefix [ 
	^ self subclassResponsibility
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporter >> contextFor: aMessageNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> contextStrategy [

	^ contextStrategy
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> contextStrategy: aSymbol [

	contextStrategy := aSymbol
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entries [

	^ entries
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsCompletionJsonString [

	^ NeoJSONWriter toString: (entries collect: [ :entry |
		   Dictionary new
			   at: 'context' put: (entry at: #context);
			   at: 'candidates' put: (entry at: #candidates);
			at: 'fetchers' put: (entry at: #fetchers);
			   at: 'correct' put: (entry at: #correct);
			   yourself ])
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsCompletionJsonlString [

	^ String cr join: (entries collect: [ :entry |
		   NeoJSONWriter toString: (Dictionary new
				   at: 'context' put: (entry at: #context);
				   at: 'candidates' put: (entry at: #candidates);
				   at: 'fetchers' put: (entry at: #fetchers);
				   at: 'correct' put: (entry at: #correct);
				   yourself) ])
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> entriesAsInfillJsonString [

	^ NeoJSONWriter toString: (entries collect: [ :entry |
		   Dictionary new
			   at: 'prefix_code' put: (entry at: #context);
			   at: 'suffix_code' put: (entry at: #suffix ifAbsent: [ '' ]);
			   at: 'target' put: (entry at: #target ifAbsent: [ entry at: #correct ]);
			   yourself ])
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsInfillJsonlString [

	^ String cr join: (entries collect: [ :entry |
		   NeoJSONWriter toString: (Dictionary new
				   at: 'prefix_code' put: (entry at: #context);
				   at: 'suffix_code' put: (entry at: #suffix ifAbsent: [ '' ]);
				   at: 'target' put: (entry at: #target ifAbsent: [ entry at: #correct ]);
				   yourself) ])
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> entriesAsJsonString [

	^ outputFormat
		  caseOf: {
				  ([ #infill ] -> [ self entriesAsInfillJsonString ]).
				  ([ #reranker ] -> [ self entriesAsRerankerJsonString ]) }
		  otherwise: [ self entriesAsCompletionJsonString ]
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsJsonlString [
	"Return entries serialized as JSONL (one JSON object per line), respecting the current outputFormat."

	^ outputFormat
		  caseOf: {
				  ([ #infill ] -> [ self entriesAsInfillJsonlString ]).
				  ([ #reranker ] -> [ self entriesAsRerankerJsonlString ]) }
		  otherwise: [ self entriesAsCompletionJsonlString ]
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> entriesAsRerankerJsonString [

	^ NeoJSONWriter toString: (entries collect: [ :entry |
		   | correct candidateTexts fetchers candidates correctFound |
		   correct := entry at: #correct.
		   candidateTexts := entry at: #candidates.
		   fetchers := entry at: #fetchers.
		   correctFound := false.

		   candidates := candidateTexts withIndex collect: [ :text :rank |
			                   | isCorrect |
			                   isCorrect := text = correct.
			                   isCorrect ifTrue: [ correctFound := true ].
			                   Dictionary new
				                   at: 'text' put: text;
				                   at: 'fetcher' put: (fetchers at: rank ifAbsent: [ '' ]);
				                   at: 'baseline_rank' put: rank;
				                   at: 'label' put: (isCorrect
						                    ifTrue: [ 1 ]
						                    ifFalse: [ 0 ]);
				                   yourself ].

		   correctFound ifFalse: [
			   candidates := candidates copyWith: (Dictionary new
					                    at: 'text' put: correct;
					                    at: 'fetcher' put: '';
					                    at: 'baseline_rank' put: candidates size + 1;
					                    at: 'label' put: 1;
					                    yourself) ].

		   Dictionary new
			   at: 'context_before' put: (entry at: #context);
			   at: 'context_after' put: (entry at: #suffix ifAbsent: [ '' ]);
			   at: 'language' put: 'Smalltalk';
			   at: 'candidates' put: candidates;
			   yourself ])
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsRerankerJsonlString [

	^ String cr join: (entries collect: [ :entry |
		   | correct candidateTexts fetchers candidates correctFound |
		   correct := entry at: #correct.
		   candidateTexts := entry at: #candidates.
		   fetchers := entry at: #fetchers.
		   correctFound := false.

		   candidates := candidateTexts withIndex collect: [ :text :rank |
			                   | isCorrect |
			                   isCorrect := text = correct.
			                   isCorrect ifTrue: [ correctFound := true ].
			                   Dictionary new
				                   at: 'text' put: text;
				                   at: 'fetcher' put: (fetchers at: rank ifAbsent: [ '' ]);
				                   at: 'baseline_rank' put: rank;
				                   at: 'label' put: (isCorrect
						                    ifTrue: [ 1 ]
						                    ifFalse: [ 0 ]);
				                   yourself ].

		   correctFound ifFalse: [
			   candidates := candidates copyWith: (Dictionary new
					                    at: 'text' put: correct;
					                    at: 'fetcher' put: '';
					                    at: 'baseline_rank' put: candidates size + 1;
					                    at: 'label' put: 1;
					                    yourself) ].

		   NeoJSONWriter toString: (Dictionary new
				   at: 'context_before' put: (entry at: #context);
				   at: 'context_after' put: (entry at: #suffix ifAbsent: [ '' ]);
				   at: 'language' put: 'Smalltalk';
				   at: 'candidates' put: candidates;
				   yourself) ])
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> initialize [

	super initialize.
	entries := OrderedCollection new.
	outputFormat := #completion
]

{ #category : 'Protocol (as yet unclassified) - 4 selector(s)' }
CooCompletionDatasetExporter >> lineCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [

	| source position endIndex lineStart linePrefix |
	source := aNode methodNode source.
	position := (aPosition respondsTo: #first)
		            ifTrue: [ aPosition first ]
		            ifFalse: [ aPosition ].
	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.

	lineStart := endIndex.
	[ lineStart > 0 and: [
		| current |
		current := source at: lineStart.
		(current ~= Character lf) and: [ current ~= Character cr ] ] ]
		whileTrue: [ lineStart := lineStart - 1 ].
	lineStart := lineStart + 1.
	lineStart := lineStart max: 1.

	linePrefix := endIndex < lineStart
		              ifTrue: [ '' ]
		              ifFalse: [ source copyFrom: lineStart to: endIndex ].
	^ linePrefix , prefix
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> outputFormat [

	^ outputFormat
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> outputFormat: aSymbol [

	outputFormat := aSymbol
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> recordCandidateInfoFor: aCandidate [

	| fetcherName fetcher |
	fetcherName := ''.
	(aCandidate respondsTo: #fetcher) ifTrue: [
		fetcher := aCandidate fetcher.
		fetcherName := (fetcher respondsTo: #name)
			               ifTrue: [ fetcher name ]
			               ifFalse: [ fetcher printString ] ].
	(aCandidate respondsTo: #fetcherName) ifTrue: [
		fetcherName := aCandidate fetcherName ].

	^ fetcherName
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> recordContext: context candidates: candidates correct: originalValue [

	self
		recordContext: context
		suffix: ''
		target: originalValue
		candidates: candidates
		correct: originalValue
]

{ #category : 'initialization' }
CooCompletionDatasetExporter >> recordContext: context suffix: suffixCode target: target candidates: candidates correct: originalValue [

	entries add: (Dictionary new
			 at: #context put: context;
			 at: #suffix put: suffixCode;
			 at: #target put: target;
			 at: #candidates put: (candidates collect: [ :each | each contents ]);
			 at: #fetchers put: (candidates collect: [ :each | self recordCandidateInfoFor: each ]);
			 at: #correct put: originalValue;
			 yourself)
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> sourceForNode: aNode inMethodSource: source [

	| interval |
	(aNode isNil or: [ source isNil ]) ifTrue: [ ^ '' ].

	interval := (aNode respondsTo: #sourceInterval)
		            ifTrue: [ aNode sourceInterval ]
		            ifFalse: [ nil ].
	(interval notNil and: [ interval size >= 2 ]) ifTrue: [
		^ source copyFrom: interval first to: interval last ].

	^ aNode printString
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [

	| source position endIndex prefixContext |
	source := aNode methodNode source.
	position := (aPosition respondsTo: #first)
		            ifTrue: [ aPosition first ]
		            ifFalse: [ aPosition ].
	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.

	prefixContext := endIndex < 1
		                 ifTrue: [ '' ]
		                 ifFalse: [ source copyFrom: 1 to: endIndex ].
	^ prefixContext , prefix
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> writeToFileNamed: aString [

	| reference |
	reference := aString asFileReference.
	reference parent ensureCreateDirectory.
	reference writeStreamDo: [ :stream |
		stream
			truncate;
			nextPutAll: self entriesAsCompletionJsonString ]
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> writeToFileNamedAsJsonl: aString [

	| reference |
	reference := aString asFileReference.
	reference parent ensureCreateDirectory.
	reference writeStreamDo: [ :stream |
		stream
			truncate;
			nextPutAll: self entriesAsJsonlString ]
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> writeToFileReference: aFileReference [

	aFileReference writeStreamDo: [ :stream |
		stream
			truncate;
			nextPutAll: self entriesAsCompletionJsonString ]
]
