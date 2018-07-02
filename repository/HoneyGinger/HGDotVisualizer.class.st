Class {
	#name : #HGDotVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'radius',
		'color',
		'particleIndex'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGDotVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGDotVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGDotVisualizer class >> at: anInteger radius: aNumber color: aColor [
	^ (self basicNew)
		particleIndex: anInteger;
		radius: aNumber;
		color: aColor;
		yourself
]

{ #category : #copyrights }
HGDotVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGDotVisualizer >> color [
	^ color
]

{ #category : #accessing }
HGDotVisualizer >> color: aColor [
	color := aColor
]

{ #category : #drawing }
HGDotVisualizer >> draw: anHGSimulator on: aCanvas [
	self
		in: anHGSimulator
		particlesDo: [ :particle | 
			| p form |
			p := particle position.
			p ifNotNil: [ aCanvas fillOval: ((p x - radius) @ (p y - radius) extent: 2 @ 2 * radius) color: color ] ]
]

{ #category : #accessing }
HGDotVisualizer >> in: anHGSimulator particlesDo: aBlock [
	(anHGSimulator particleAt: particleIndex) ifNotNilDo: aBlock
]

{ #category : #accessing }
HGDotVisualizer >> particleIndex [
	^ particleIndex
]

{ #category : #accessing }
HGDotVisualizer >> particleIndex: anInteger [
	particleIndex := anInteger
]

{ #category : #accessing }
HGDotVisualizer >> radius [
	^radius 
]

{ #category : #accessing }
HGDotVisualizer >> radius: aNumber [
	radius := aNumber
]
