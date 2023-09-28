Class {
	#name : 'HGPolygonVisualizer',
	#superclass : 'HGTriangulatedVisualizer',
	#instVars : [
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGPolygonVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGPolygonVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGPolygonVisualizer class >> color: aColor [
	^ self new color: aColor; yourself
]

{ #category : 'copyrights' }
HGPolygonVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HGPolygonVisualizer >> color [
	^color
]

{ #category : 'accessing' }
HGPolygonVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGPolygonVisualizer >> drawTriangle: anHG2dTriangle alpha: aNumber on: aCanvas [
	| v1 v2 v3 |
	v1 := anHG2dTriangle vertex1 x @ anHG2dTriangle vertex1 y.
	v2 := anHG2dTriangle vertex2 x @ anHG2dTriangle vertex2 y.
	v3 := anHG2dTriangle vertex3 x @ anHG2dTriangle vertex3 y.
	aCanvas drawPolygon: (Array with: v1 with: v2 with: v3) fillStyle: (color alpha: aNumber)
]
