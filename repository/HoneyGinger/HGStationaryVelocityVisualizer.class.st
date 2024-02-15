Class {
	#name : 'HGStationaryVelocityVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'position',
		'kernel',
		'radius',
		'width',
		'scale',
		'color',
		'isTouchy'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGStationaryVelocityVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGStationaryVelocityVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGStationaryVelocityVisualizer class >> at: position kernel: kernel radius: radius width: width scale: scale color: color [
	^ (self new)
		position: position;
		kernel: kernel;
		radius: radius;
		width: width;
		scale: scale;
		color: color;
		yourself
]

{ #category : 'copyrights' }
HGStationaryVelocityVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGStationaryVelocityVisualizer >> draw: anHGSimulator on: aCanvas [
	| velocity denominator |
	velocity := HG2dPoint zero.
	denominator := 0.0.
	anHGSimulator
		neighborsOf: self position
		within: kernel support
		do: [ :neighbor :distance | 
			| r |
			r := kernel r: distance.
			velocity add: neighbor velocity by: r.
			denominator := denominator + r ].
	denominator > 0.0 ifTrue: [velocity := velocity / denominator].
	aCanvas fillOval: ((position x - radius) @ (position y - radius) extent: 2 @ 2 * radius) color: color.
	aCanvas
		line: position x @ position y
		to: (velocity x * scale + position x) @ (velocity y * scale + position y)
		width: width
		color: color
]

{ #category : 'simulating' }
HGStationaryVelocityVisualizer >> effectIn: anHGSimulator deltaT: aNumber [
	isTouchy
		ifTrue: [ 
			| newPosition |
			newPosition := World activeHand position.
			(anHGSimulator bounds containsPoint: newPosition)
				ifTrue: [ position := HG2dPoint fromPoint: newPosition - anHGSimulator bounds origin ] ].
	super effectIn: anHGSimulator deltaT: aNumber
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> handMorph [
	^ handMorph
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> handMorph: aHandMorph [
	handMorph := aHandMorph
]

{ #category : 'initialize-release' }
HGStationaryVelocityVisualizer >> initialize [
	super initialize.
	isTouchy := true
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> isTouchy [
	^ isTouchy
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> isTouchy: aBoolean [
	isTouchy := aBoolean == true
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> position [
	^ position
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> position: anHG2dPoint [
	position := anHG2dPoint
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> radius [
	^ radius
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> radius: aNumber [
	radius := aNumber
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> scale [
	^ scale
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> width [
	^ width
]

{ #category : 'accessing' }
HGStationaryVelocityVisualizer >> width: aNumber [
	width := aNumber
]
