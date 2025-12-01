Class {
	#name : 'HGTriangulatedVisualizer',
	#superclass : 'HGVisualizer',
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGTriangulatedVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGTriangulatedVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGTriangulatedVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'drawing' }
HGTriangulatedVisualizer >> draw: anHGSimulator on: aCanvas [
	| triangulator kernel |
	triangulator := HGTriangulator
		origin: anHGSimulator simulationOrigin
		corner: anHGSimulator simulationCorner
		step: 80.
	kernel := HGSimpleKernel support: 40.0.
	anHGSimulator particlesDo: [ :particle | triangulator divideAt: particle position ].
	triangulator
		trianglesDo: [ :triangle | self drawTriangle: triangle alpha: ((anHGSimulator countAt: triangle center kernel: kernel) / 5.0 min: 1.0) on: aCanvas ]
]

{ #category : 'drawing' }
HGTriangulatedVisualizer >> drawTriangle: anHG2dTriangle alpha: aNumber on: aCanvas [
	^ self subclassResponsibility
]
