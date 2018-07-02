Class {
	#name : #HGPump,
	#superclass : #HGAction,
	#instVars : [
		'position',
		'v'
	],
	#category : 'HoneyGinger-Actions-Mechanics'
}

{ #category : #'instance creation' }
HGPump class >> v: anHG2dPoint at: anotherHG2dPoint [
	^ (self new)
		v: anHG2dPoint;
		position: anotherHG2dPoint;
		yourself
]

{ #category : #drawing }
HGPump >> draw: anHGSimulator on: aCanvas [
	aCanvas frameOval: (self position asPoint - (10@10) extent: 20@20) color: Color black.
	aCanvas line: self position asPoint to: (self position + self v) asPoint width: 5 color: Color blue muchDarker
]

{ #category : #simulating }
HGPump >> effectIn: anHGSimulator deltaT: aNumber [
	(anHGSimulator addParticleAt: 0 @ 0 temperature: 400 mass: 300)
		velocity: v copy;
		position: self position copy;
		viscosity: 0.9.
	self draw: anHGSimulator on: anHGSimulator form getCanvas
]

{ #category : #accessing }
HGPump >> position [
	^ position
]

{ #category : #accessing }
HGPump >> position: anObject [
	position := anObject
]

{ #category : #accessing }
HGPump >> v [
	^ v
]

{ #category : #accessing }
HGPump >> v: anObject [
	v := anObject
]
