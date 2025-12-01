Class {
	#name : 'HGWorldImageVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'simulatorTopMorph',
		'simulatorMorph'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'drawing' }
HGWorldImageVisualizer >> draw: anHGSimulator on: aCanvas [
	"aCanvas drawImage: World imageForm at: simulatorMorph position negated."
	World submorphs size to: (World submorphs indexOf: simulatorTopMorph) + 1
	by: -1 do: [ :index | 
		| morph form |
		morph := World submorphs at: index.
		form := morph imageForm.
		aCanvas drawImage: form at: morph position - simulatorMorph position ]
]

{ #category : 'simulating' }
HGWorldImageVisualizer >> effectIn: anHGSimulator deltaT: aNumber [
	simulatorMorph := anHGSimulator.
	simulatorTopMorph := anHGSimulator.
	[ simulatorTopMorph owner == World
		or: [ simulatorTopMorph owner isNil ] ]
		whileFalse: [ simulatorTopMorph := simulatorTopMorph owner ].
	super effectIn: anHGSimulator deltaT: aNumber
]
