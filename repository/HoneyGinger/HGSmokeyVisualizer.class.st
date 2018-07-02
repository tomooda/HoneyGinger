Class {
	#name : #HGSmokeyVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'kernel',
		'scale',
		'forms'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #'instance creation' }
HGSmokeyVisualizer class >> kernel: anHGKernel scale: aNumber color: aColor [
	^ self
		kernel: anHGKernel
		scale: aNumber
		steps: 50
		extent: 5 @ 5
		color: aColor
]

{ #category : #'instance creation' }
HGSmokeyVisualizer class >> kernel: anHGKernel scale: aNumber steps: anInteger extent: aPoint color: aColor [
	^ (self new)
		kernel: anHGKernel;
		scale: aNumber;
		initializeForms: anInteger extent: aPoint color: aColor;
		yourself
]

{ #category : #drawing }
HGSmokeyVisualizer >> draw: anHGSimulator on: aCanvas [
	| random xstep ystep xgrids ygrids |
	random := Random new.
	xstep := forms first first extent x asFloat.
	ystep := forms first first extent y asFloat.
	xgrids := (anHGSimulator extent x / xstep) ceiling.
	ygrids := (anHGSimulator extent y / ystep) ceiling.
	0 to: xgrids - 1 do: [ :xIndex | 
		| x |
		x := xstep / 2.0 + (xstep * xIndex) + anHGSimulator simulationOrigin x.
		0 to: ygrids - 1 do: [ :yIndex | 
			| y pressure denominator |
			y := ystep / 2.0 + (ystep * yIndex) + anHGSimulator simulationOrigin y.
			pressure := 0.0.
			denominator := 0.0.
			anHGSimulator
				neighborsOf: (HG2dPoint x: x y: y)
				within: kernel support
				do: [ :neighbor :distance | 
					| r |
					r := kernel r: distance.
					pressure := neighbor pressure * r + pressure.
					denominator := denominator + r ].
			denominator > 0.0
				ifTrue: [ pressure := pressure / denominator ].
			pressure := (pressure * scale) floor + 1 min: forms size max: 1.
			aCanvas translucentImage: ((forms at: pressure) at: (random next * 10 + 1) floor) at: (x - (xstep / 2.0)) rounded @ (y - (ystep / 2.0)) rounded]]
]

{ #category : #'initialize-release' }
HGSmokeyVisualizer >> initializeForms: anInteger extent: aPoint color: aColor [
	| random |
	random := Random new.
	forms := (1 to: anInteger) collect: [ :index | | factor |
		factor := index - 1.0 / (anInteger - 1).
		(1 to: 10) collect: [:variation | | form |
		form := Form extent: aPoint depth: 32.
		0 to: aPoint x - 1 do: [ :x | 0 to: aPoint y - 1 do: [ :y | form colorAt: x@y put: (aColor alpha: (random next * factor min: 1.0 max: 0.0))]].
		form ]]
		
]

{ #category : #accessing }
HGSmokeyVisualizer >> kernel [
	^ kernel
]

{ #category : #accessing }
HGSmokeyVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel
]

{ #category : #accessing }
HGSmokeyVisualizer >> scale [
	^ scale
]

{ #category : #accessing }
HGSmokeyVisualizer >> scale: aNumber [
	scale := aNumber
]
