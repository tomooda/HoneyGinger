Class {
	#name : #HGWorldSubmorphsObstacle,
	#superclass : #HGAction,
	#instVars : [
		'simulatorTopMorph',
		'boundsExpansion'
	],
	#category : #'HoneyGinger-Actions-Simulation'
}

{ #category : #'instance creation' }
HGWorldSubmorphsObstacle class >> withBoundsExpansion: aNumber [
	^ (self new)
		boundsExpansion: aNumber;
		yourself
]

{ #category : #accessing }
HGWorldSubmorphsObstacle >> boundsExpansion [
	^ boundsExpansion
]

{ #category : #accessing }
HGWorldSubmorphsObstacle >> boundsExpansion: aNumber [
	boundsExpansion := aNumber
]

{ #category : #simulating }
HGWorldSubmorphsObstacle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [

	| scale position morphicPosition |
	scale := anHGSimulator scale.
	position := anHGParticle position.
	morphicPosition := position x * scale + anHGSimulator left
	                   @ (position y * scale + anHGSimulator top).
	1 to: (World submorphs indexOf: simulatorTopMorph) - 1 do: [ :index | 
		| submorph |
		submorph := World submorphs at: index.
		self
			effect: anHGParticle
			position: position
			morphicPosition: morphicPosition
			morphicBounds: submorph bounds.
		position := anHGParticle position.
		morphicPosition := position x * scale + anHGSimulator left
		                   @ (position y * scale + anHGSimulator top) ].
	self
		effect: anHGParticle
		position: position
		morphicPosition: morphicPosition
		morphicBounds: World activeHand bounds
]

{ #category : #private }
HGWorldSubmorphsObstacle >> effect: anHGParticle position: position morphicPosition: morphicPosition morphicBounds: bounds [
	| morphicBounds delta minDelta newPosition |
	morphicBounds := bounds expandBy: boundsExpansion.
	(morphicBounds containsPoint: morphicPosition) ifFalse: [^self].
	minDelta := Float infinity.
	minDelta := morphicPosition x - morphicBounds left.
	newPosition := HG2dPoint x: position x - minDelta y: position y.
	delta := morphicBounds right - morphicPosition x.
	delta < minDelta
		ifTrue: [ 
			minDelta := delta.
			newPosition := HG2dPoint x: position x + delta y: position y ].
	delta := morphicPosition y - morphicBounds top.
	delta < minDelta
		ifTrue: [ 
			minDelta := delta.
			newPosition := HG2dPoint x: position x y: position y - delta ].
	delta := morphicBounds bottom - morphicPosition y.
	delta < minDelta
		ifTrue: [ 
			minDelta := delta.
			newPosition := HG2dPoint x: position x y: position y + delta ].
	anHGParticle velocity set: HG2dPoint zero.
	anHGParticle position set: newPosition
]

{ #category : #simulating }
HGWorldSubmorphsObstacle >> effectIn: anHGSimulator deltaT: aNumber [
	simulatorTopMorph := anHGSimulator.
	[ simulatorTopMorph owner == World or: [ simulatorTopMorph owner isNil ] ]
		whileFalse: [ simulatorTopMorph := simulatorTopMorph owner ].
	super effectIn: anHGSimulator deltaT: aNumber
]

{ #category : #'initialize-release' }
HGWorldSubmorphsObstacle >> initialize [
	super initialize.
	boundsExpansion := 0
]
