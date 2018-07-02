Class {
	#name : #HGSlipperyObstacle,
	#superclass : #HGObstacle,
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #simulating }
HGSlipperyObstacle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| position |
	position := anHGParticle position.
	(region contains: position)
		ifTrue: [ 
			| newPosition |
			newPosition := region borderAt: position.
			anHGParticle addVelocity: (newPosition plus: position by: -1.0) by: 1.0.
			anHGParticle position set: (newPosition).
			afterEffect ifNotNil: [ afterEffect value: anHGParticle value: aNumber ] ]
]
