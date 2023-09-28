Class {
	#name : 'HGDotsVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'radius',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGDotsVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGDotsVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGDotsVisualizer class >> dot [
	^ self radius: 0.5 color: Color black
]

{ #category : 'instance creation' }
HGDotsVisualizer class >> new [
	^ self dot
]

{ #category : 'instance creation' }
HGDotsVisualizer class >> radius: aNumber color: aColor [
	^ (self basicNew)
		radius: aNumber;
		color: aColor;
		yourself
]

{ #category : 'copyrights' }
HGDotsVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HGDotsVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGDotsVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGDotsVisualizer >> draw: anHGSimulator on: aCanvas [
	anHGSimulator
		particlesDo: [ :particle | 
			| p form |
			p := particle position.
			p ifNotNil: [ | r |
				r := particle at: #radius ifAbsent: [radius].
				 aCanvas fillOval: ((p x - r) @ (p y - r) extent: 2 @ 2 * r) color: color ] ]
]

{ #category : 'accessing' }
HGDotsVisualizer >> radius [
	^ radius
]

{ #category : 'accessing' }
HGDotsVisualizer >> radius: aNumber [
	radius := aNumber
]
