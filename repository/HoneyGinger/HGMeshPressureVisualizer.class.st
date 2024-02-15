Class {
	#name : 'HGMeshPressureVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'xgrids',
		'ygrids',
		'kernel',
		'scale',
		'bias',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGMeshPressureVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGMeshPressureVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGMeshPressureVisualizer class >> color: aColor [
	^ self
		xgrids: 60
		ygrids: 60
		kernel: (HGSimpleKernel support: 15)
		scale: 0.2
		bias: 0.0
		color: aColor
]

{ #category : 'instance creation' }
HGMeshPressureVisualizer class >> new [
	^ self
		xgrids: 60
		ygrids: 60
		kernel: (HGSimpleKernel support: 10)
		scale: 0.2
		bias: 0.0
		color: Color white
]

{ #category : 'instance creation' }
HGMeshPressureVisualizer class >> scale: scale bias: bias color: aColor [
	^ self
		xgrids: 60
		ygrids: 60
		kernel: (HGSimpleKernel support: 15)
		scale: scale
		bias: bias
		color: aColor
]

{ #category : 'copyrights' }
HGMeshPressureVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGMeshPressureVisualizer class >> xgrids: xgirds ygrids: ygrids kernel: kernel scale: scale bias: bias color: color [
	^ (self basicNew)
		initialize;
		xgrids: xgirds;
		ygrids: ygrids;
		kernel: kernel;
		scale: scale;
		bias: bias;
		color: color;
		yourself
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> bias [
	^ bias ifNil: [bias := 0.0]
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> bias: aNumber [
	bias := aNumber
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> color: aColor [
	color := aColor 
]

{ #category : 'drawing' }
HGMeshPressureVisualizer >> draw: anHGSimulator on: aCanvas [
	| xstep ystep |
	xstep := (anHGSimulator simulationCorner x - anHGSimulator simulationOrigin x) / xgrids asFloat.
	ystep := (anHGSimulator simulationCorner y - anHGSimulator simulationOrigin y) / ygrids asFloat.
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
			pressure := pressure * scale + self bias.
			aCanvas
				fillRectangle:
					((x - (xstep / 2.0)) rounded @ (y - (ystep / 2.0)) rounded
						corner: (x + (xstep / 2.0)) rounded @ (y + (ystep / 2.0)) rounded)
				color: (color alpha: (pressure min: 1.0 max: 0.0)) ] ]
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel 
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> scale [
	^ scale
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> xgrids [
	^ xgrids
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> xgrids: anInteger [
	xgrids := anInteger 
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> ygrids [
	^ ygrids 
]

{ #category : 'accessing' }
HGMeshPressureVisualizer >> ygrids: anInteger [
	ygrids := anInteger 
]
