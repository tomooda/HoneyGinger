Class {
	#name : 'HGRecyclingBoundingBox',
	#superclass : 'HGAction',
	#instVars : [
		'recyclingBlock'
	],
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'instance creation' }
HGRecyclingBoundingBox class >> recyclingBlock: aBlock [
	^ (self new)
		recyclingBlock: aBlock;
		yourself
]

{ #category : 'instance creation' }
HGRecyclingBoundingBox class >> sprintAtHand [
	^ self
		recyclingBlock: [ :simulator :particle | 
			particle velocity: HG2dPoint zero.
			particle
				position:
					(HG2dPoint fromPoint: (simulator random next - 0.5) @ (simulator random next * 2.0 - 1.8) * 40.0 + World activeHand position - simulator position ) ]
]

{ #category : 'simulating' }
HGRecyclingBoundingBox >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| x0 y0 x1 y1 position velocity |
	x0 := anHGSimulator simulationOrigin x.
	y0 := anHGSimulator simulationOrigin y.
	x1 := anHGSimulator simulationCorner x.
	y1 := anHGSimulator simulationCorner y.
	position := anHGParticle position.
	velocity := anHGParticle velocity.
	(position x < x0 or: [ position x > x1 or: [ position y < y0 or: [ position y > y1 ] ] ])
		ifTrue: [ recyclingBlock value: anHGSimulator value: anHGParticle ]
]

{ #category : 'accessing' }
HGRecyclingBoundingBox >> recyclingBlock [
	^ recyclingBlock 
]

{ #category : 'accessing' }
HGRecyclingBoundingBox >> recyclingBlock: aBlock [
	recyclingBlock := aBlock
]
