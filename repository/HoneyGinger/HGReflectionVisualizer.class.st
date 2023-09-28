Class {
	#name : 'HGReflectionVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'vector',
		'xgrids',
		'ygrids',
		'kernel',
		'scale',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGReflectionVisualizer class >> vector: anHG2dPoint color: aColor [
	^ self xgrids: 60 ygrids: 60 kernel: (HGSimpleKernel support: 40) vector: anHG2dPoint scale: 0.5 color: aColor
]

{ #category : 'instance creation' }
HGReflectionVisualizer class >> xgrids: xgirds ygrids: ygrids kernel: kernel vector: anHG2dPoint scale: scale color: aColor [
	^ (self new)
		xgrids: xgirds;
		ygrids: ygrids;
		kernel: kernel;
		vector: anHG2dPoint;
		scale: scale;
		color: aColor;
		yourself
]

{ #category : 'accessing' }
HGReflectionVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGReflectionVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGReflectionVisualizer >> draw: anHGSimulator on: aCanvas [
	| random xstep ystep extent |
	random := Random new.
	xstep := (anHGSimulator simulationCorner x - anHGSimulator simulationOrigin x) / xgrids asFloat.
	ystep := (anHGSimulator simulationCorner y - anHGSimulator simulationOrigin y) / ygrids asFloat.
	extent := (xstep @ ystep) ceiling.
	0 to: xgrids - 1 do: [ :xIndex | 
		| x |
		x := xstep / 2.0 + (xstep * xIndex) + anHGSimulator simulationOrigin x.
		0 to: ygrids - 1 do: [ :yIndex | 
			| y position norm r denominator origin |
			y := ystep / 2.0 + (ystep * yIndex) + anHGSimulator simulationOrigin y.
			position := HG2dPoint x: x y: y.
			norm := HG2dPoint zero.
			denominator := 0.0.
			anHGSimulator
				neighborsOf: position
				within: kernel support
				do: [ :neighbor :distance | 
					| gradient |
					gradient := kernel r: distance.
					norm add: (neighbor position unitVector: position) by: (neighbor pressure * gradient min: 100.0 max: -100.0).
					denominator := denominator + gradient ].
			denominator > 0.0
				ifTrue: [ norm div: denominator].
			origin := (x - (xstep / 2.0)) @ (y - (ystep / 2.0)).
			norm add: vector by: -1.0.
			r := norm r.
			r < 0.5 ifTrue: [
			aCanvas fillRectangle: ((x - (xstep / 2.0)) rounded @ (y - (ystep / 2.0)) rounded
						corner: (x + (xstep / 2.0)) rounded @ (y + (ystep / 2.0)) rounded) color: (color alpha: (0.5 - r * 5.0 min: 1.0)) ]]]
]

{ #category : 'initialize-release' }
HGReflectionVisualizer >> initialize [
	super initialize.
	scale := 1.0.
	vector := HG2dPoint zero.
]

{ #category : 'accessing' }
HGReflectionVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel 
]

{ #category : 'accessing' }
HGReflectionVisualizer >> scale [
	^ scale
]

{ #category : 'accessing' }
HGReflectionVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : 'accessing' }
HGReflectionVisualizer >> vector [
	^ vector
]

{ #category : 'accessing' }
HGReflectionVisualizer >> vector: anHG2dPoint [
	vector := anHG2dPoint
]

{ #category : 'accessing' }
HGReflectionVisualizer >> xgrids: anInteger [
	xgrids := anInteger 
]

{ #category : 'accessing' }
HGReflectionVisualizer >> ygrids: anInteger [
	ygrids := anInteger 
]
