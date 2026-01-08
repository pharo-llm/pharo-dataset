"
Available contexts
- #completion:           	receiver expression and the requested prefix (completion-ctx-messages.json)
- #surroundingCompletion:	source up to the call site plus the requested prefix (completion-surrounding-ctx-messages.json)
	- #lineCompletion:      	source line up to the call site plus the requested prefix (completion-surrounding-line-ctx-messages.json)
"
Class {
	#name : 'CooCompletionDatasetExporterMessages',
	#superclass : 'CooCompletionDatasetExporter',
	#category : 'HeuristicCompletion-Generator',
	#package : 'HeuristicCompletion-Generator'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterMessages class >> exportAllMessages [

	<script>
	^ self
		  exportOnPackages:
			  #( 'Iceberg' 'Iceberg-ArchitecturalRules' 'Iceberg-Libgit' 'Iceberg-Libgit-Filetree' 'Iceberg-Libgit-Tonel'
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
		  heuristics: [ :builder | builder messageHeuristic ]
		  context: #completion
		  to: 'completion-ctx-messages.json'
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterMessages class >> exportnec [

	<script>
	^ self
		  exportOnPackages: #( 'NECompletion' )
		  heuristics: [ :builder | builder messagesHeuristic ]
		  context: #lineCompletion
		  to: 'completion-ctx-line-messages.json'
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessages >> benchCallsite: aMessageNode inMethod: aMethod atPosition: aPosition [

	| originalSelector position |
	originalSelector := aMessageNode selector.
	position := (aPosition respondsTo: #first)
		            ifTrue: [ aPosition first ]
		            ifFalse: [ aPosition ].

	2 to: (self maxPrefixSizeFor: originalSelector) do: [ :index |
		| prefix completion candidates context |
		prefix := self extractPrefixFrom: originalSelector at: index.
		aMessageNode selector: prefix.

		completion := self buildCompletionFor: aMessageNode atPosition: position.

		candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.

		context := self
			           contextFor: aMessageNode
			           inMethod: aMethod
			           atPosition: position
			           withPrefix: prefix.

		self recordContext: context candidates: candidates correct: originalSelector ].

	aMessageNode selector: originalSelector
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
				   -> [ self surroundingCompletionContextFor: aMessageNode atPosition: aPosition withPrefix: prefix ]) }
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
