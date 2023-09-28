Class {
	#name : 'HG2dRectangle',
	#superclass : 'HG2dRegion',
	#instVars : [
		'origin',
		'corner'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'copyrights' }
HG2dRectangle class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dRectangle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HG2dRectangle class >> origin: anHG2dPoint corner: anotherHG2dPoint [
	^ self new setOrigin: anHG2dPoint corner: anotherHG2dPoint
]

{ #category : 'instance creation' }
HG2dRectangle class >> originX: x0 originY: y0 cornerX: x1 cornerY: y1 [
	^ self new setOrigin: (HG2dPoint x: x0 y: y0) corner: (HG2dPoint x: x1 y: y1)
]

{ #category : 'copyrights' }
HG2dRectangle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HG2dRectangle >> area [
	^ (corner x - origin x) * (corner y - origin y)
]

{ #category : 'accessing' }
HG2dRectangle >> borderAt: anHG2dPoint [
	^ (self contains: anHG2dPoint)
		ifTrue: [ 
			| dx x dy y |
			anHG2dPoint x - origin x < (corner x - anHG2dPoint x)
				ifTrue: [ 
					dx := anHG2dPoint x - origin x.
					x := origin x ]
				ifFalse: [ 
					dx := corner x - anHG2dPoint x.
					x := corner x ].
			anHG2dPoint y - origin y < (corner y - anHG2dPoint y)
				ifTrue: [ 
					dy := anHG2dPoint y - origin y.
					y := origin y ]
				ifFalse: [ 
					dy := corner y - anHG2dPoint y.
					y := corner y ].
			dx < dy
				ifTrue: [ HG2dPoint x: x y: anHG2dPoint y ]
				ifFalse: [ HG2dPoint x: anHG2dPoint x y: y ] ]
		ifFalse: [ 
			HG2dPoint
				x:
					(anHG2dPoint x < origin x
						ifTrue: [ origin x ]
						ifFalse: [ 
							anHG2dPoint x > corner x
								ifTrue: [ corner x ]
								ifFalse: [ anHG2dPoint x ] ])
				y:
					(anHG2dPoint y < origin y
						ifTrue: [ origin y ]
						ifFalse: [ 
							anHG2dPoint y > corner y
								ifTrue: [ corner y ]
								ifFalse: [ anHG2dPoint y ] ]) ]
]

{ #category : 'accessing' }
HG2dRectangle >> center [
	^ origin + corner div: 2
]

{ #category : 'accessing' }
HG2dRectangle >> center: anHG2dPoint [
	| diff |
	diff := anHG2dPoint - self center.
	origin := origin + diff.
	corner := corner + diff.
	bounds := HG2dRectangle
		originX: origin x
		originY: origin y
		cornerX: corner x
		cornerY: corner y
]

{ #category : 'testing' }
HG2dRectangle >> conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint [
	| x1 y1 x2 y2 xMin xMax yMin yMax xAtOrigin xAtCorner yAtOrigin yAtCorner |
	x1 := anHG2dPoint x.
	y1 := anHG2dPoint y.
	x2 := anotherHG2dPoint x.
	y2 := anotherHG2dPoint y.
	(x1 > origin x and: [ x1 < corner x and: [ y1 > origin y and: [ y1 < corner y ] ] ])
		ifTrue: [ ^ true ].
	(x2 > origin x and: [ x2 < corner x and: [ y2 > origin y and: [ y2 < corner y ] ] ])
		ifTrue: [ ^ true ].
	xMin := x1 min: x2.
	xMin > corner x
		ifTrue: [ ^ false ].
	xMax := x1 max: x2.
	xMax < origin x
		ifTrue: [ ^ false ].
	yMin := y1 min: y2.
	yMin > corner y
		ifTrue: [ ^ false ].
	yMax := y1 max: y2.
	yMax < origin y
		ifTrue: [ ^ false ].
	xAtOrigin := (x2 - x1) * (origin y - y1) / (y2 - y1) + x1.
	(xAtOrigin > origin x and: [ xAtOrigin < corner x ])
		ifTrue: [ ^ true ].
	xAtCorner := (x2 - x1) * (corner y - y1) / (y2 - y1) + x1.
	(xAtCorner > origin x and: [ xAtCorner < corner x ])
		ifTrue: [ ^ true ].
	yAtOrigin := (y2 - y1) * (origin x - x1) / (x2 - x1) + y1.
	(yAtOrigin > origin y and: [ yAtOrigin < corner y ])
		ifTrue: [ ^ true ].
	yAtCorner := (y2 - y1) * (corner x - x1) / (x2 - x1) + y1.
	(yAtCorner > origin y and: [ yAtCorner < corner y ])
		ifTrue: [ ^ true ].
	^ false
]

{ #category : 'testing' }
HG2dRectangle >> contains: anHG2dPoint [
	| x y |
	x := anHG2dPoint x.
	y := anHG2dPoint y.
	^ origin x <= x and: [ x <= corner x and: [ origin y <= y and: [ y <= corner y ] ] ]
]

{ #category : 'accessing' }
HG2dRectangle >> corner [
	^ corner
]

{ #category : 'accessing' }
HG2dRectangle >> depth: anHG2dPoint [
	| dx1 dy1 dx2 dy2 |
	(dx1 := anHG2dPoint x - origin x) < 0.0
		ifTrue: [ ^ 0.0 ].
	(dy1 := anHG2dPoint y - origin y) < 0.0
		ifTrue: [ ^ 0.0 ].
	(dx2 := corner x - anHG2dPoint x) < 0.0
		ifTrue: [ ^ 0.0 ].
	(dy2 := corner y - anHG2dPoint y) < 0.0
		ifTrue: [ ^ 0.0 ].
	^ ((dx1 min: dy1) min: dx2) min: dy2
]

{ #category : 'accessing' }
HG2dRectangle >> distance: anHG2dPoint [
	anHG2dPoint x <= origin x
		ifTrue: [ 
			anHG2dPoint y <= origin y
				ifTrue: [ ^ ((origin x - anHG2dPoint x) squared + (origin y - anHG2dPoint y) squared) sqrt ].
			corner y <= anHG2dPoint y
				ifTrue: [ ^ ((origin x - anHG2dPoint x) squared + (corner y - anHG2dPoint y) squared) sqrt ].
			^ (origin x - anHG2dPoint x) abs ].
	corner x <= anHG2dPoint x
		ifTrue: [ 
			anHG2dPoint y <= origin y
				ifTrue: [ ^ ((corner x - anHG2dPoint x) squared + (origin y - anHG2dPoint y) squared) sqrt ].
			corner y <= anHG2dPoint y
				ifTrue: [ ^ ((corner x - anHG2dPoint x) squared + (corner y - anHG2dPoint y) squared) sqrt ].
			^ (corner x - anHG2dPoint x) abs ].
	anHG2dPoint y <= origin y
		ifTrue: [ ^ (origin y - anHG2dPoint y) abs ].
	corner y <= anHG2dPoint y
		ifTrue: [ ^ (corner y - anHG2dPoint y) abs ].
	^ 0.0
]

{ #category : 'drawing' }
HG2dRectangle >> drawOn: aCanvas color: aColor [
	aCanvas fillRectangle: (origin x @ origin y corner: corner x @ corner y) fillStyle: aColor borderStyle: BorderStyle default

]

{ #category : 'accessing' }
HG2dRectangle >> normAt: anHG2dPoint [
	| minDistance norm d |
	minDistance := (origin x - anHG2dPoint x) abs.
	norm := #left.
	d := (corner x - anHG2dPoint x) abs.
	d <= minDistance
		ifTrue: [ 
			minDistance := d.
			norm := #right ].
	d := (origin y - anHG2dPoint y) abs.
	d <= minDistance
		ifTrue: [ 
			minDistance := d.
			norm := #up ].
	d := (corner y - anHG2dPoint y) abs.
	d < minDistance
		ifTrue: [ norm := #down ].
	norm == #left
		ifTrue: [ ^ HG2dPoint x: -1.0 y: 0.0 ].
	norm == #right
		ifTrue: [ ^ HG2dPoint x: 1.0 y: 0.0 ].
	norm == #up
		ifTrue: [ ^ HG2dPoint x: 0.0 y: -1.0 ].
	^ HG2dPoint x: 0 y: 1.0
]

{ #category : 'accessing' }
HG2dRectangle >> origin [
	^ origin
]

{ #category : 'printing' }
HG2dRectangle >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	origin printOn: aStream.
	aStream nextPut: $-.
	aStream space.
	corner printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'private' }
HG2dRectangle >> setOrigin: anHG2dPoint corner: anotherHG2dPoint [
	origin := anHG2dPoint .
	corner := anotherHG2dPoint 
]
