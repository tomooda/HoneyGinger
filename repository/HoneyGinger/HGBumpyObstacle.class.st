Class {
	#name : 'HGBumpyObstacle',
	#superclass : 'HGObstacle',
	#instVars : [
		'rate'
	],
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'instance creation' }
HGBumpyObstacle class >> with: anHG2dRegion  color: aColor [
	^ self with: anHG2dRegion rate: 1.0 color: aColor
]

{ #category : 'instance creation' }
HGBumpyObstacle class >> with: anHG2dRegion rate: aNumber color: aColor [
	^ (self new)
		setRegion: anHG2dRegion color: aColor;
		rate: aNumber;
		yourself
]

{ #category : 'simulating' }
HGBumpyObstacle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| position |
	position := anHGParticle position.
	(region contains: position)
		ifTrue: [ 
			| newPosition |
			newPosition := region borderAt: position.
			anHGParticle addVelocity: (position unitVector: newPosition) by: rate / aNumber.
			anHGParticle position set: newPosition.
			afterEffect ifNotNil: [ afterEffect value: anHGParticle value: aNumber] ]
]

{ #category : 'initialize-release' }
HGBumpyObstacle >> initialize [
	super initialize.
	rate := 1.0
]

{ #category : 'accessing' }
HGBumpyObstacle >> rate [
	^ rate
]

{ #category : 'accessing' }
HGBumpyObstacle >> rate: aNumber [
	rate := aNumber
]
