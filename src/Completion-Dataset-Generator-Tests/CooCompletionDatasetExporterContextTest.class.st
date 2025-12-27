Class {
	#name : 'CooCompletionDatasetExporterContextTest',
	#superclass : 'TestCase',
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testMessagesCompletionContextUsesReceiverSource [

	| exporter methodNode receiver messageNode context |
	exporter := CooCompletionDatasetExporterMessages new.
	methodNode := CooCompletionDatasetExporterTestMethodNode withSource: 'self foo'.
	receiver := CooCompletionDatasetExporterTestNode new
		methodNode: methodNode;
		sourceInterval: (1 to: 4);
		yourself.
	messageNode := CooCompletionDatasetExporterTestMessageNode new
		receiver: receiver;
		methodNode: methodNode;
		yourself.

	context := exporter completionContextFor: messageNode withPrefix: 'ba'.

	self assert: context equals: 'self ba'
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testMessagesContextFallsBackToSurroundingCompletion [

	| exporter methodNode messageNode context |
	exporter := CooCompletionDatasetExporterMessages new.
	exporter contextStrategy: #unknown.
	methodNode := CooCompletionDatasetExporterTestMethodNode withSource: 'abc'.
	messageNode := CooCompletionDatasetExporterTestMessageNode new
		methodNode: methodNode;
		yourself.

	context := exporter
		contextFor: messageNode
		inMethod: nil
		atPosition: 2
		withPrefix: 'Z'.

	self assert: context equals: 'aZ'
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testSourceForNodeFallsBackToPrintStringWhenNoInterval [

	| exporter methodNode node |
	exporter := CooCompletionDatasetExporter new.
	methodNode := CooCompletionDatasetExporterTestMethodNode withSource: 'ignored'.
	node := CooCompletionDatasetExporterTestNode new
		methodNode: methodNode;
		printStringValue: 'node-value';
		yourself.

	self
		assert: (exporter sourceForNode: node inMethodSource: methodNode source)
		equals: 'node-value'
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testSourceForNodeReturnsEmptyForNilInputs [

	| exporter node |
	exporter := CooCompletionDatasetExporter new.
	node := CooCompletionDatasetExporterTestNode new.

	self assert: (exporter sourceForNode: nil inMethodSource: 'abc') equals: ''.
	self assert: (exporter sourceForNode: node inMethodSource: nil) equals: ''
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testSourceForNodeUsesSourceInterval [

	| exporter methodNode node |
	exporter := CooCompletionDatasetExporter new.
	methodNode := CooCompletionDatasetExporterTestMethodNode withSource: 'abc def'.
	node := CooCompletionDatasetExporterTestNode new
		methodNode: methodNode;
		sourceInterval: (1 to: 3);
		yourself.

	self
		assert: (exporter sourceForNode: node inMethodSource: methodNode source)
		equals: 'abc'
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testSurroundingCompletionContextHandlesPositions [

	| exporter methodNode node |
	exporter := CooCompletionDatasetExporter new.
	methodNode := CooCompletionDatasetExporterTestMethodNode withSource: 'abcde'.
	node := CooCompletionDatasetExporterTestNode new
		methodNode: methodNode;
		yourself.

	self
		assert: (exporter surroundingCompletionContextFor: node atPosition: 1 withPrefix: 'X')
		equals: 'X'.
	self
		assert: (exporter surroundingCompletionContextFor: node atPosition: 3 withPrefix: 'X')
		equals: 'abX'.
	self
		assert: (exporter surroundingCompletionContextFor: node atPosition: 99 withPrefix: 'X')
		equals: 'abcdeX'
]

{ #category : 'tests' }
CooCompletionDatasetExporterContextTest >> testVariablesContextUsesCompletionStrategy [

	| exporter node context |
	exporter := CooCompletionDatasetExporterVariables new.
	exporter contextStrategy: #completion.
	node := CooCompletionDatasetExporterTestVariableNode named: 'VariableName'.

	context := exporter
		contextFor: node
		inMethod: nil
		atPosition: 1
		withPrefix: 'Var'.

	self assert: context equals: 'Var'
]
