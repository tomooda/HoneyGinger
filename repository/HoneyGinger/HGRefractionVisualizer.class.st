Class {
	#name : #HGRefractionVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'image',
		'xgrids',
		'ygrids',
		'kernel',
		'scale'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #'instance creation' }
HGRefractionVisualizer class >> scale: aNumber [
	^ self
		xgrids: 60
		ygrids: 60
		kernel: (HGSimpleKernel support: 40)
		scale: aNumber
		image: nil
]

{ #category : #'instance creation' }
HGRefractionVisualizer class >> scale: aNumber image: aForm [ 
	^ self
		xgrids: 60
		ygrids: 60
		kernel: (HGSimpleKernel support: 40)
		scale: aNumber
		image: aForm
]

{ #category : #'instance creation' }
HGRefractionVisualizer class >> xgrids: xgirds ygrids: ygrids kernel: kernel scale: scale image: image [
	^ (self new)
		xgrids: xgirds;
		ygrids: ygrids;
		kernel: kernel;
		scale: scale;
		image: image;
		yourself
]

{ #category : #drawing }
HGRefractionVisualizer >> draw: anHGSimulator on: aCanvas [
	| form xstep ystep extent offset |
	form := image ifNil: [anHGSimulator form].
	xstep := (anHGSimulator simulationCorner x - anHGSimulator simulationOrigin x) / xgrids asFloat.
	ystep := (anHGSimulator simulationCorner y - anHGSimulator simulationOrigin y) / ygrids asFloat.
	extent := (xstep @ ystep) ceiling.
	offset := form extent - anHGSimulator extent // 2.
	0 to: xgrids - 1 do: [ :xIndex | 
		| x |
		x := xstep / 2.0 + (xstep * xIndex) + anHGSimulator simulationOrigin x.
		0 to: ygrids - 1 do: [ :yIndex | 
			| y position norm denominator origin |
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
				ifTrue: [ norm div: denominator ].
			origin := (x - (xstep / 2.0)) @ (y - (ystep / 2.0)).
			aCanvas
				drawImage: form
				at: origin floor
				sourceRect: (((norm mul: scale negated) asPoint + origin) floor + offset extent: extent) ] ]
]

{ #category : #accessing }
HGRefractionVisualizer >> image [
	^ image
]

{ #category : #accessing }
HGRefractionVisualizer >> image: anImage [
	image := anImage
]

{ #category : #'initialize-release' }
HGRefractionVisualizer >> initialize [
	super initialize.
	scale := 1.0.
]

{ #category : #accessing }
HGRefractionVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel 
]

{ #category : #accessing }
HGRefractionVisualizer >> scale [
	^ scale
]

{ #category : #accessing }
HGRefractionVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : #accessing }
HGRefractionVisualizer >> xgrids: anInteger [
	xgrids := anInteger 
]

{ #category : #accessing }
HGRefractionVisualizer >> ygrids: anInteger [
	ygrids := anInteger 
]
