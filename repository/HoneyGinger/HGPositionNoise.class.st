Class {
	#name : #HGPositionNoise,
	#superclass : #HGAction,
	#instVars : [
		'randomBlock'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #'instance creation' }
HGPositionNoise class >> withBlock: aRandomBlock [
	^ (self new)
		randomBlock: aRandomBlock;
		yourself
]

{ #category : #simulating }
HGPositionNoise >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	anHGParticle addPosition: randomBlock value by: 1.0.
]

{ #category : #accessing }
HGPositionNoise >> randomBlock [
	^ randomBlock
]

{ #category : #accessing }
HGPositionNoise >> randomBlock: aBlock [
	randomBlock := aBlock
]
