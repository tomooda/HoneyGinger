Class {
	#name : #HGPerspectiveVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'eyeHeight',
		'depthBlock',
		'vanishingPoint'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #'instance creation' }
HGPerspectiveVisualizer class >> eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock [
	^ self new
		eyeHeight: height;
		vanishingPoint: point;
		depthBlock: simulatorAndParticleBlock;
		yourself
]

{ #category : #accessing }
HGPerspectiveVisualizer >> depthBlock [
	^ depthBlock
]

{ #category : #accessing }
HGPerspectiveVisualizer >> depthBlock: aBlock [
	depthBlock := aBlock
]

{ #category : #drawing }
HGPerspectiveVisualizer >> drawCornersIn: anHGSimulator on: aCanvas [
	| cornerBlock |
	cornerBlock := [ :position | 
	| x y z a r |
	x := position x - vanishingPoint x.
	y := position y - vanishingPoint y.
	a := 0.5.
	x := x * a + vanishingPoint x.
	y := y * a + vanishingPoint y.
	aCanvas
		line: position asPoint
		to: x @ y
		width: 1
		color: Color black ].
	cornerBlock value: anHGSimulator simulationOrigin x @ anHGSimulator simulationOrigin y.
	cornerBlock value: anHGSimulator simulationOrigin x @ anHGSimulator simulationCorner y.
	cornerBlock value: anHGSimulator simulationCorner x @ anHGSimulator simulationOrigin y.
	cornerBlock value: anHGSimulator simulationCorner x @ anHGSimulator simulationCorner y.

]

{ #category : #accessing }
HGPerspectiveVisualizer >> eyeHeight [
	^ eyeHeight
]

{ #category : #accessing }
HGPerspectiveVisualizer >> eyeHeight: aNumber [
	eyeHeight := aNumber
]

{ #category : #projecting }
HGPerspectiveVisualizer >> project: anHGParticle in: anHGSimulator do: aBlock [
	| p x y z a c r |
	p := anHGParticle position.
	p isNil
		ifTrue: [ ^ nil ].
	x := p x - vanishingPoint x.
	y := p y - vanishingPoint y.
	z := depthBlock value: anHGSimulator value: anHGParticle.
	a := eyeHeight / (eyeHeight + z).
	^ aBlock value: x * a + vanishingPoint x value: y * a + vanishingPoint y value: z value: a
]

{ #category : #projecting }
HGPerspectiveVisualizer >> projectPoint: aPoint z: aNumber in: anHGSimulator do: aBlock [
	|  x y a |
	x := aPoint x - vanishingPoint x.
	y := aPoint y - vanishingPoint y.
	a := eyeHeight / (eyeHeight + aNumber).
	^ aBlock value: x * a + vanishingPoint x value: y * a + vanishingPoint y value: aNumber value: a
]

{ #category : #accessing }
HGPerspectiveVisualizer >> vanishingPoint [
	^ vanishingPoint
]

{ #category : #accessing }
HGPerspectiveVisualizer >> vanishingPoint: anHG2dPoint [
	vanishingPoint := anHG2dPoint
]
