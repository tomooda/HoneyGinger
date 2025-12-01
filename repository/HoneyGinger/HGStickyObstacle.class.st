Class {
	#name : 'HGStickyObstacle',
	#superclass : 'HGObstacle',
	#instVars : [
		'relativePositions'
	],
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'simulating' }
HGStickyObstacle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| position |
	position := anHGParticle position.
	(region contains: position)
		ifTrue: [ 
			anHGParticle velocity set: HG2dPoint zero.
			anHGParticle position
				set:
					(relativePositions at: anHGParticle ifAbsentPut: [ (region borderAt: position) - region center ]) + region center.
			afterEffect ifNotNil: [ afterEffect value: anHGParticle value: aNumber] ]
		ifFalse: [ relativePositions removeKey: anHGParticle ifAbsent: [  ] ]
]

{ #category : 'initialize-release' }
HGStickyObstacle >> initialize [
	super initialize.
	relativePositions := IdentityDictionary new.
]
