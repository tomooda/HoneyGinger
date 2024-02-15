Class {
	#name : 'HGMeshVelocityVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'xgrids',
		'ygrids',
		'kernel',
		'radius',
		'width',
		'scale',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGMeshVelocityVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGMeshVelocityVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGMeshVelocityVisualizer class >> new [
	^ self
		xgrids: 30
		ygrids: 30
		kernel: (HGSimpleKernel support: 20)
		radius: 0.5
		width: 1
		scale: 1.0
		color: Color black
]

{ #category : 'copyrights' }
HGMeshVelocityVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGMeshVelocityVisualizer class >> xgrids: xgirds ygrids: ygrids kernel: kernel radius: radius width: width scale: scale color: color [
	^ (self basicNew)
		xgrids: xgirds;
		ygrids: ygrids;
		kernel: kernel;
		radius: radius;
		width: width;
		scale: scale;
		color: color;
		yourself
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> color: aColor [
	color := aColor 
]

{ #category : 'drawing' }
HGMeshVelocityVisualizer >> draw: anHGSimulator on: aCanvas [
	| xstep ystep |
	xstep := (anHGSimulator simulationCorner x - anHGSimulator simulationOrigin x) / xgrids asFloat.
	ystep := (anHGSimulator simulationCorner y - anHGSimulator simulationOrigin y) / ygrids asFloat.
	0 to: xgrids - 1 do: [ :xIndex | 
		| x |
		x := xstep / 2.0 + (xstep * xIndex) + anHGSimulator simulationOrigin x.
		0 to: ygrids - 1 do: [ :yIndex | 
			| y velocity denominator |
			y := ystep / 2.0 + (ystep * yIndex) + anHGSimulator simulationOrigin y.
			velocity := HG2dPoint zero.
			denominator := 0.0.
			anHGSimulator
				neighborsOf: (HG2dPoint x: x y: y)
				within: kernel support
				do: [ :neighbor :distance | 
					| r |
					r := kernel r: distance.
					velocity add: neighbor velocity by: r.
					denominator := denominator + r ].
			denominator > 0.0
				ifTrue: [ velocity := velocity / denominator ].
			aCanvas fillOval: ((x - radius) @ (y - radius) extent: 2 @ 2 * radius) color: color.
			aCanvas
				line: x @ y
				to: (velocity x * scale + x) @ (velocity y * scale + y)
				width: width
				color: color ] ]
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> radius [
	^ radius
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> radius: aNumber [
	radius := aNumber 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> scale [
	^ scale
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> width [
	^ width 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> width: aNumber [
	width := aNumber 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> xgrids [
	^ xgrids
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> xgrids: anInteger [
	xgrids := anInteger 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> ygrids [
	^ ygrids 
]

{ #category : 'accessing' }
HGMeshVelocityVisualizer >> ygrids: anInteger [
	ygrids := anInteger 
]
