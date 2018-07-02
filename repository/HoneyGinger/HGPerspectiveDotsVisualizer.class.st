Class {
	#name : #HGPerspectiveDotsVisualizer,
	#superclass : #HGPerspectiveVisualizer,
	#instVars : [
		'colorBlock',
		'radius',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #'instance creation' }
HGPerspectiveDotsVisualizer class >> radius: radius color: color eyeHeight: depth vanishingPoint: point depthBlock: simulatorAndParticleBlock [
	^ self
		radius: radius
		color: color
		eyeHeight: depth
		vanishingPoint: point
		depthBlock: simulatorAndParticleBlock
		colorBlock: [ :c :z | c alpha: depth / (depth + z) ]
]

{ #category : #'instance creation' }
HGPerspectiveDotsVisualizer class >> radius: radius color: color eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock colorBlock: colorAndDepthBlock [
	^ (self eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock)
		radius: radius;
		color: color;
		colorBlock: colorAndDepthBlock;
		yourself
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> color [
	^ color
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> color: aColor [
	color := aColor
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> colorBlock [
	^ colorBlock
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> colorBlock: aBlock [
	colorBlock := aBlock
]

{ #category : #drawing }
HGPerspectiveDotsVisualizer >> draw: anHGSimulator on: aCanvas [
	self drawCornersIn: anHGSimulator on: aCanvas.
	anHGSimulator
		particlesDo: [ :particle | 
			self
				project: particle
				in: anHGSimulator
				do: [ :x :y :z :a | 
					((x between: 0 and: aCanvas extent x) and: [ y between: 0 and: aCanvas extent y ])
						ifTrue: [ 
							| c r |
							c := colorBlock value: color value: z.
							r := (particle at: #radius ifAbsent: [ radius ]) * a max: 0.5.
							aCanvas fillOval: ((x - r) @ (y - r) extent: 2 @ 2 * r) color: c ] ] ]
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> radius [
	^ radius
]

{ #category : #accessing }
HGPerspectiveDotsVisualizer >> radius: aNumber [
	radius := aNumber
]
