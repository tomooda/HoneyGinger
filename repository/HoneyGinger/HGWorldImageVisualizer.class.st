Class {
	#name : #HGWorldImageVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'simulatorTopMorph',
		'simulatorMorph'
	],
	#category : #'HoneyGinger-Actions-UI'
}

{ #category : #drawing }
HGWorldImageVisualizer >> draw: anHGSimulator on: aCanvas [
	World submorphs size to: (World submorphs indexOf: simulatorTopMorph) + 1
	by: -1 do: [ :index | 
		| morph form |
		morph := World submorphs at: index.
		form := morph imageForm.
		aCanvas drawImage: form at: morph position - simulatorMorph position ]
]

{ #category : #simulating }
HGWorldImageVisualizer >> effectIn: anHGSimulator deltaT: aNumber [
	simulatorMorph := anHGSimulator.
	simulatorTopMorph := anHGSimulator.
	[ simulatorTopMorph owner == World
		or: [ simulatorTopMorph owner isNil ] ]
		whileFalse: [ simulatorTopMorph := simulatorTopMorph owner ].
	super effectIn: anHGSimulator deltaT: aNumber
]
