Class {
	#name : 'HGWireframeVisualizer',
	#superclass : 'HGTriangulatedVisualizer',
	#instVars : [
		'width',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGWireframeVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGWireframeVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGWireframeVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGWireframeVisualizer class >> width: aNumber color: aColor [
	^ (self new)
		width: aNumber;
		color: aColor;
		yourself
]

{ #category : 'accessing' }
HGWireframeVisualizer >> color [
	^color
]

{ #category : 'accessing' }
HGWireframeVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGWireframeVisualizer >> drawTriangle: anHG2dTriangle alpha: aNumber on: aCanvas [
	| v1 v2 v3 c |
	v1 := anHG2dTriangle vertex1 x @ anHG2dTriangle vertex1 y.
	v2 := anHG2dTriangle vertex2 x @ anHG2dTriangle vertex2 y.
	v3 := anHG2dTriangle vertex3 x @ anHG2dTriangle vertex3 y.
	c := color alpha: aNumber.
	aCanvas
		line: v1
		to: v2
		width: width
		color: c.
	aCanvas
		line: v2
		to: v3
		width: width
		color: c.
	aCanvas
		line: v3
		to: v1
		width: width
		color: c
]

{ #category : 'drawing' }
HGWireframeVisualizer >> drawTriangle: anHG2dTriangle on: aCanvas [
	| v1 v2 v3 c |
	v1 := anHG2dTriangle vertex1 x @ anHG2dTriangle vertex1 y.
	v2 := anHG2dTriangle vertex2 x @ anHG2dTriangle vertex2 y.
	v3 := anHG2dTriangle vertex3 x @ anHG2dTriangle vertex3 y.
	c := color alpha: 100.0 / (anHG2dTriangle area max: 100.0).
	aCanvas
		line: v1
		to: v2
		width: width
		color: c.
	aCanvas
		line: v2
		to: v3
		width: width
		color: c.
	aCanvas
		line: v3
		to: v1
		width: width
		color: c
]

{ #category : 'accessing' }
HGWireframeVisualizer >> width [
	^width
]

{ #category : 'accessing' }
HGWireframeVisualizer >> width: aNumber [
	width := aNumber
]
