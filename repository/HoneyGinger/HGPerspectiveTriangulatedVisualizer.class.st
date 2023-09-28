Class {
	#name : 'HGPerspectiveTriangulatedVisualizer',
	#superclass : 'HGPerspectiveVisualizer',
	#instVars : [
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGPerspectiveTriangulatedVisualizer class >> color: aColor eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock [
	^ (self eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock) color: aColor; yourself
]

{ #category : 'accessing' }
HGPerspectiveTriangulatedVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGPerspectiveTriangulatedVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGPerspectiveTriangulatedVisualizer >> draw: anHGSimulator on: aCanvas [
	| triangulator particleMap kernel |
	self drawCornersIn: anHGSimulator on: aCanvas.
	triangulator := HGTriangulator origin: anHGSimulator simulationOrigin corner: anHGSimulator simulationCorner step: 80.
	particleMap := IdentityDictionary new: anHGSimulator numberOfParticles.
	kernel := HGSimpleKernel support: 40.0.
	anHGSimulator
		particlesDo: [ :particle | 
			triangulator divideAt: particle position.
			particleMap at: particle position put: particle ].
	triangulator
		trianglesDo: [ :triangle | 
			| p1 p2 p3 v1 v2 v3 |
			p1 := particleMap at: triangle vertex1 ifAbsent: [  ].
			p2 := particleMap at: triangle vertex2 ifAbsent: [  ].
			p3 := particleMap at: triangle vertex3 ifAbsent: [  ].
			(p1 notNil and: [ p2 notNil and: [ p3 notNil ] ])
				ifTrue: [ 
					v1 := self
						project: p1
						in: anHGSimulator
						do: [ :x :y :z :a | 
							((x between: 0 and: aCanvas extent x) and: [ y between: 0 and: aCanvas extent y ])
								ifTrue: [ x @ y ] ].
					v2 := self
						project: p2
						in: anHGSimulator
						do: [ :x :y :z :a | 
							((x between: 0 and: aCanvas extent x) and: [ y between: 0 and: aCanvas extent y ])
								ifTrue: [ x @ y ] ].
					v3 := self
						project: p3
						in: anHGSimulator
						do: [ :x :y :z :a | 
							((x between: 0 and: aCanvas extent x) and: [ y between: 0 and: aCanvas extent y ])
								ifTrue: [ x @ y ] ].
					(v1 notNil and: [ v2 notNil and: [ v3 notNil ] ])
						ifTrue: [ 
							self
								drawTriangle: v1
								and: v2
								and: v3
								color: (self color alpha: ((anHGSimulator countAt: triangle center kernel: kernel) / 5.0 min: 1.0))
								on: aCanvas ] ] ]
]

{ #category : 'drawing' }
HGPerspectiveTriangulatedVisualizer >> drawTriangle: aPoint1 and: aPoint2 and: aPoint3 color: aColor on: aCanvas [
	^ self subclassResponsibility 
]
