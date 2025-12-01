Class {
	#name : 'HG2dCircle',
	#superclass : 'HG2dRegion',
	#instVars : [
		'center',
		'radius'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'copyrights' }
HG2dCircle class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dCircle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HG2dCircle class >> center: anHG2dPoint radius: aNumber [
	^ self new setCenter: anHG2dPoint radius: aNumber
]

{ #category : 'instance creation' }
HG2dCircle class >> centerX: x centerY: y radius: r [
	^ self new setCenter: (HG2dPoint x: x y: y) radius: r
]

{ #category : 'copyrights' }
HG2dCircle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HG2dCircle >> area [
	^Float pi * radius * radius
]

{ #category : 'accessing' }
HG2dCircle >> borderAt: anHG2dPoint [
	^ center plus: (self normAt: anHG2dPoint) by: radius
]

{ #category : 'accessing' }
HG2dCircle >> center [
	^ center
]

{ #category : 'accessing' }
HG2dCircle >> center: anHG2dPoint [
	center := anHG2dPoint.
	bounds := HG2dRectangle
		originX: center x - radius
		originY: center y - radius
		cornerX: center x + radius
		cornerY: center y + radius
]

{ #category : 'testing' }
HG2dCircle >> conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint [
	^ (center distance: (anHG2dPoint to: anotherHG2dPoint nearestFrom: center)) < radius
]

{ #category : 'testing' }
HG2dCircle >> contains: anHG2dPoint [
	^ (bounds contains: anHG2dPoint) and: [(anHG2dPoint x - center x) squared + (anHG2dPoint y - center y) squared < (radius * radius)]
]

{ #category : 'accessing' }
HG2dCircle >> depth: anHG2dPoint [
	^ radius - ((center x - anHG2dPoint x) squared + (center y - anHG2dPoint y) squared) sqrt max: 0.0
]

{ #category : 'accessing' }
HG2dCircle >> distance: anHG2dPoint [
	^ ((center x - anHG2dPoint x) squared + (center y - anHG2dPoint y) squared) sqrt - radius max: 0.0
]

{ #category : 'drawing' }
HG2dCircle >> drawOn: aCanvas color: aColor [
	aCanvas
		fillOval: ((center x - radius) @ (center y - radius) extent: radius @ radius * 2)
		fillStyle: aColor
		borderWidth: 0
		borderColor: nil
]

{ #category : 'accessing' }
HG2dCircle >> normAt: anHG2dPoint [
	| x y r |
	x := anHG2dPoint x - center x.
	y := anHG2dPoint y - center y.
	r := (x * x + (y * y)) sqrt.
	^ r > 0.0
		ifTrue: [ HG2dPoint x: x / r y: y / r ]
		ifFalse: [ HG2dPoint x: 1.0 y: 0.0 ]
]

{ #category : 'printing' }
HG2dCircle >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	center printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	radius printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
HG2dCircle >> radius [
	^ radius
]

{ #category : 'accessing' }
HG2dCircle >> radius: aNumber [
	radius := aNumber.
	bounds := HG2dRectangle
		originX: center x - radius
		originY: center y - radius
		cornerX: center x + radius
		cornerY: center y + radius
]

{ #category : 'private' }
HG2dCircle >> setCenter: anHG2dPoint radius: aNumber [
	center := anHG2dPoint.
	radius := aNumber.
	bounds := HG2dRectangle
		originX: center x - radius
		originY: center y - radius
		cornerX: center x + radius
		cornerY: center y + radius
]
