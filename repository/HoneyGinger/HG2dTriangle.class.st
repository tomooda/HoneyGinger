Class {
	#name : 'HG2dTriangle',
	#superclass : 'HG2dRegion',
	#instVars : [
		'vertex1',
		'vertex2',
		'vertex3'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'copyrights' }
HG2dTriangle class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dTriangle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'examples' }
HG2dTriangle class >> example1 [
	"HG2dTriangle example1"
	| triangle |
	triangle := HG2dTriangle on: (HG2dPoint x: 1.0 y: -1.0) on: (HG2dPoint x: 0.0 y: 1.0) on: (HG2dPoint x: -1.0 y: -1.0).
	triangle contains: (HG2dPoint x: 0.0 y: 0.0).
	^triangle
]

{ #category : 'instance creation' }
HG2dTriangle class >> on: anHG2dPoint1 on: anHG2dPoint2 on: anHG2dPoint3 [
	^ self new setVertex1: anHG2dPoint1 vertex2: anHG2dPoint2 vertex3: anHG2dPoint3
]

{ #category : 'copyrights' }
HG2dTriangle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HG2dTriangle >> area [
	^ (vertex1 to: vertex2 cross: vertex3) / 2.0
]

{ #category : 'accessing' }
HG2dTriangle >> borderAt: anHG2dPoint [
	|  point distance minDistance nearestPoint |
	point := vertex1 to: vertex2 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	minDistance := distance.
	nearestPoint := point.
	point := vertex2 to: vertex3 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestPoint := point ].
	point := vertex3 to: vertex1 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestPoint := point ].
	^ nearestPoint
]

{ #category : 'accessing' }
HG2dTriangle >> center [
	^ vertex1 + vertex2 + vertex3 / 3.0
]

{ #category : 'testing' }
HG2dTriangle >> conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint [
	^ (self contains: anHG2dPoint)
		or: [ 
			(self contains: anotherHG2dPoint)
				or: [ 
					(vertex1 to: vertex2 conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint)
						or: [ 
							(vertex2 to: vertex3 conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint)
								or: [ vertex3 to: vertex1 conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint ] ] ] ]
]

{ #category : 'testing' }
HG2dTriangle >> contains: anHG2dPoint [
	^ (bounds contains: anHG2dPoint)
		and: [ 
			(vertex1 to: vertex2 cross: anHG2dPoint) >= 0.0
				and: [ (vertex2 to: vertex3 cross: anHG2dPoint) >= 0.0 and: [ (vertex3 to: vertex1 cross: anHG2dPoint) >= 0.0 ] ] ]
]

{ #category : 'accessing' }
HG2dTriangle >> depth: anHG2dPoint [
	^ (self contains: anHG2dPoint)
		ifTrue: [ 
			((vertex1 to: vertex2 distance: anHG2dPoint) min: (vertex2 to: vertex3 distance: anHG2dPoint))
				min: (vertex3 to: vertex1 distance: anHG2dPoint) ]
		ifFalse: [ 0.0 ]
]

{ #category : 'accessing' }
HG2dTriangle >> distance: anHG2dPoint [
	^ (self contains: anHG2dPoint)
		ifTrue: [ 0.0 ]
		ifFalse: [ 
			((vertex1 to: vertex2 distance: anHG2dPoint) min: (vertex2 to: vertex3 distance: anHG2dPoint))
				min: (vertex3 to: vertex1 distance: anHG2dPoint) ]
]

{ #category : 'drawing' }
HG2dTriangle >> drawOn: aCanvas color: aColor [
	"Display the receiver, a spline curve, approximated by straight 
	line segments."

	aCanvas
		drawPolygon: (Array with: vertex1 x @ vertex1 y with: vertex2 x @ vertex2 y with: vertex3 x @ vertex3 y)
		fillStyle: aColor
]

{ #category : 'accessing' }
HG2dTriangle >> minAngle [
	| area d l12 l23 l31 angle1 angle2 angle3 |
	area := vertex1 to: vertex2 cross: vertex3.
	l12 := (d := vertex1 x - vertex2 x) * d + ((d := vertex1 y - vertex2 y) * d).
	l23 := (d := vertex2 x - vertex3 x) * d + ((d := vertex2 y - vertex3 y) * d).
	l31 := (d := vertex3 x - vertex1 x) * d + ((d := vertex3 y - vertex1 y) * d).
	^l12 < l23
		ifTrue: [ 
			l12 < l31
				ifTrue: [ area / (l23 * l31) sqrt ]
				ifFalse: [ area /( l12 * l23) sqrt ] ]
		ifFalse: [ 
			l23 < l31
				ifTrue: [ area / (l12 * l31) sqrt ]
				ifFalse: [ area / (l12 * l23) sqrt ] ]
]

{ #category : 'accessing' }
HG2dTriangle >> normAt: anHG2dPoint [
	| nearestPointBlock point distance minDistance norm |
	nearestPointBlock := [ :p1 :p2 :p3 | (p2 - p1) * ((p1 to: p2 dot: p3) min: 1.0 max: 0.0) + p1 ].
	point := nearestPointBlock value: vertex1 value: vertex2 value: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	minDistance := distance.
	norm := HG2dPoint x: vertex2 y - vertex1 y y: vertex1 x - vertex2 x.
	point := nearestPointBlock value: vertex2 value: vertex3 value: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			norm := HG2dPoint x: vertex3 y - vertex2 y y: vertex2 x - vertex3 x ].
	point := nearestPointBlock value: vertex3 value: vertex1 value: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			norm := HG2dPoint x: vertex1 y - vertex3 y y: vertex3 x - vertex1 x ].
	^ norm unit
]

{ #category : 'printing' }
HG2dTriangle >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	vertex1 printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	vertex2 printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	vertex3 printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'private' }
HG2dTriangle >> setVertex1: anHG2dPoint1 vertex2: anHG2dPoint2 vertex3: anHG2dPoint3 [
	vertex1 := anHG2dPoint1.
	vertex2 := anHG2dPoint2.
	vertex3 := anHG2dPoint3.
	bounds := HG2dRectangle
		origin: (HG2dPoint x: ((vertex1 x min: vertex2 x) min: vertex3 x) y: ((vertex1 y min: vertex2 y) min: vertex3 y))
		corner: (HG2dPoint x: ((vertex1 x max: vertex2 x) max: vertex3 x) y: ((vertex1 y max: vertex2 y) max: vertex3 y))
]

{ #category : 'accessing' }
HG2dTriangle >> vertex1 [
	^ vertex1
]

{ #category : 'accessing' }
HG2dTriangle >> vertex2 [
	^ vertex2
]

{ #category : 'accessing' }
HG2dTriangle >> vertex3 [
	^ vertex3
]
