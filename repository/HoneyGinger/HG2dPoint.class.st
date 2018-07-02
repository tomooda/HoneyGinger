Class {
	#name : #HG2dPoint,
	#superclass : #HGPoint,
	#instVars : [
		'x',
		'y'
	],
	#category : 'HoneyGinger-Geometry-Points'
}

{ #category : #copyrights }
HG2dPoint class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HG2dPoint class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #utilities }
HG2dPoint class >> areaFromVolume: aNumber [
	^ aNumber raisedTo: 0.5
]

{ #category : #'instance creation' }
HG2dPoint class >> fromNumber: aNumber [
	^ self x: aNumber y: aNumber
]

{ #category : #'instance creation' }
HG2dPoint class >> fromPoint: aPoint [
	^ self x: aPoint x y: aPoint y
]

{ #category : #utilities }
HG2dPoint class >> lengthFromVolume: aNumber [
	^ aNumber raisedTo: 0.5
]

{ #category : #'instance creation' }
HG2dPoint class >> randomFrom: anHG2dPoint to: anotherHG2dPoint with: aRandom [
	^ self
		x: (anotherHG2dPoint x - anHG2dPoint x) * aRandom next + anHG2dPoint x
		y: (anotherHG2dPoint y - anHG2dPoint y) * aRandom next + anHG2dPoint y
]

{ #category : #copyrights }
HG2dPoint class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HG2dPoint class >> theta: rad r: radius [
	^ self x: rad cos * radius y: rad sin * radius
]

{ #category : #'instance creation' }
HG2dPoint class >> x: aNumber y: anotherNumber [
	^self new setX: aNumber y: anotherNumber
]

{ #category : #'instance creation' }
HG2dPoint class >> zero [
	^ self x: 0.0 y: 0.0
]

{ #category : #arithmetics }
HG2dPoint >> * aNumber [
	^ self class x: x * aNumber y: y * aNumber
]

{ #category : #arithmetics }
HG2dPoint >> + anHG2dPoint [
	^ self class x: x + anHG2dPoint x y: y + anHG2dPoint y
]

{ #category : #arithmetics }
HG2dPoint >> - anHG2dPoint [
	^ self class x: x - anHG2dPoint x y: y - anHG2dPoint y
	"^self copy minus: anHG2dPoint "
]

{ #category : #arithmetics }
HG2dPoint >> / aNumber [
	^ self class x: x / aNumber y: y / aNumber
]

{ #category : #arithmetics }
HG2dPoint >> // aNumber [
	^ self class x: x // aNumber y: y // aNumber
]

{ #category : #comparing }
HG2dPoint >> < anHG2dPoint [
	^x < anHG2dPoint x and: [y < anHG2dPoint y]
]

{ #category : #comparing }
HG2dPoint >> <= anHG2dPoint [
	^x <= anHG2dPoint x and: [y <= anHG2dPoint y]
]

{ #category : #comparing }
HG2dPoint >> = anHG2dPoint [
	^ self class == anHG2dPoint class and: [ x = anHG2dPoint x and: [ y = anHG2dPoint y ] ]
]

{ #category : #comparing }
HG2dPoint >> > anHG2dPoint [
	^x > anHG2dPoint x and: [y > anHG2dPoint y]
]

{ #category : #comparing }
HG2dPoint >> >= anHG2dPoint [
	^x >= anHG2dPoint x and: [y >= anHG2dPoint y]
]

{ #category : #arithmetics }
HG2dPoint >> add: aPoint by: aNumber [
	x := aPoint x * aNumber + x.
	y := aPoint y * aNumber + y
]

{ #category : #arithmetics }
HG2dPoint >> add: aPoint minus: anotherPoint by: aNumber [
	x := (aPoint x - anotherPoint x) * aNumber + x.
	y := (aPoint y - anotherPoint y) * aNumber + y
]

{ #category : #arithmetics }
HG2dPoint >> add: aPoint over: aNumber [
	x := aPoint x / aNumber + x.
	y := aPoint y / aNumber + y
]

{ #category : #converting }
HG2dPoint >> asPoint [
	^ x @ y
]

{ #category : #arithmetics }
HG2dPoint >> ceiling [ 
	^ self class x: x ceiling y: y ceiling
]

{ #category : #enumerating }
HG2dPoint >> corner: anHGPoint do: aBlock [
	x to: anHGPoint x do: [ :x0 | y to: anHGPoint y do: [ :y0 | aBlock value: (self class x: x0 y: y0) ] ]
]

{ #category : #enumerating }
HG2dPoint >> corner: anHGPoint elementsDo: aBlock [
	x to: anHGPoint x do: [ :x0 | y to: anHGPoint y do: [ :y0 | aBlock value: x0 value: y0 ] ]
]

{ #category : #accessing }
HG2dPoint >> dimensions [
	^2
]

{ #category : #vector }
HG2dPoint >> distance: anHG2dPoint [
	^ ((x - anHG2dPoint x) squared + (y - anHG2dPoint y) squared) sqrt
]

{ #category : #arithmetics }
HG2dPoint >> div: aNumber [
	x := x / aNumber.
	y := y / aNumber
]

{ #category : #arithmetics }
HG2dPoint >> dot: anHG2dPoint [
	^ x * anHG2dPoint x + (y * anHG2dPoint y)
]

{ #category : #arithmetics }
HG2dPoint >> floor [
	^ self class x: x floor y: y floor
]

{ #category : #comparing }
HG2dPoint >> hash [
	^x hash bitXor: y hash
]

{ #category : #testing }
HG2dPoint >> in: anHG2dPoint radius: aNumber [
	^ (x - anHG2dPoint x) abs < aNumber
		and: [ (y - anHG2dPoint y) abs < aNumber and: [ super in: anHG2dPoint radius: aNumber ] ]
]

{ #category : #accessing }
HG2dPoint >> indexIn: anHGPoint [
	^ (0 <= x and: [ x < anHGPoint x and: [ 0 <= y and: [ y < anHGPoint y ] ] ])
		ifTrue: [ x * anHGPoint y + y + 1 ]
]

{ #category : #vector }
HG2dPoint >> laplace: aBlock delta: aNumber [
	| v vx1 vx2 vy1 vy2 |
	v := aBlock value: self.
	vx1 := aBlock value: (self class x: x - aNumber y: y).
	vx2 := aBlock value: (self class x: x + aNumber y: y).
	vy1 := aBlock value: (self class x: x y: y - aNumber).
	vy2 := aBlock value: (self class x: x y: y + aNumber).
	^ ((vx2 - v) / aNumber - ((v - vx1) / aNumber)) / aNumber + (((vy2 - v) / aNumber - ((v - vy1) / aNumber)) / aNumber)
]

{ #category : #vector }
HG2dPoint >> length: aNumber [
	| denominator |
	denominator := ((x * x) + (y * y)) sqrt / aNumber.
	x := x / denominator.
	y := y / denominator
]

{ #category : #arithmetics }
HG2dPoint >> min: anHG2dPoint max: anotherHG2dPoint [
	^ self class x: (x min: anHG2dPoint x max: anotherHG2dPoint x) y: (y min: anHG2dPoint y max: anotherHG2dPoint y)
]

{ #category : #arithmetics }
HG2dPoint >> mul: aNumber [
	x := x * aNumber.
	y := y * aNumber
]

{ #category : #vector }
HG2dPoint >> norm1 [
	^ x abs + y abs
]

{ #category : #vector }
HG2dPoint >> norm2 [
	^ (x squared  + y squared) sqrt
]

{ #category : #vector }
HG2dPoint >> norm: aNumber [
	^ (x raisedTo: aNumber) + (y raisedTo: aNumber) raisedTo: aNumber reciprocal
]

{ #category : #arithmetics }
HG2dPoint >> plus: aPoint by: aNumber [
	^ self class x: aPoint x * aNumber + x y: aPoint y * aNumber + y
]

{ #category : #arithmetics }
HG2dPoint >> plus: aPoint over: aNumber [
	^ self class x: aPoint x / aNumber + x y: aPoint y / aNumber + y
]

{ #category : #printing }
HG2dPoint >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	x printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	y printOn: aStream.
	aStream nextPut: $)
]

{ #category : #vector }
HG2dPoint >> product [
	^ x * y
]

{ #category : #accessing }
HG2dPoint >> r [
	^ self norm2
]

{ #category : #accessing }
HG2dPoint >> set: aPoint [
	x := aPoint x.
	y := aPoint y
]

{ #category : #private }
HG2dPoint >> setX: aNumber y: anotherNumber [
	x := aNumber.
	y := anotherNumber
]

{ #category : #accessing }
HG2dPoint >> theta [
	^ y < 0.0
		ifTrue: [ Float pi * 2.0 - (x / (x * x + (y * y)) sqrt) arcCos ]
		ifFalse: [ (x / (x * x + (y * y)) sqrt) arcCos ]
]

{ #category : #testing }
HG2dPoint >> to: anHG2dPoint conflictsWithLineSegment: anotherFrom to: anotherTo [
	^ (self to: anHG2dPoint cross: anotherFrom) sign ~= (self to: anHG2dPoint cross: anotherTo) sign
		and: [ (anotherFrom to: anotherTo cross: self) sign ~= (anotherFrom to: anotherTo cross: anHG2dPoint) sign ]
]

{ #category : #testing }
HG2dPoint >> to: anHG2dPoint contains: anotherHG2dPoint [
	^ (self to: anHG2dPoint cross: anotherHG2dPoint) abs < 1.0e-1
		and: [ 
			| dot |
			dot := self to: anHG2dPoint dot: anotherHG2dPoint.
			dot between: 0.0 and: (self to: anHG2dPoint dot: anHG2dPoint) ]
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint cross: anotherHG2dPoint [
	| x1 x2 y1 y2 |
	x1 := anHG2dPoint x - x.
	x2 := anotherHG2dPoint x - x.
	y1 := anHG2dPoint y - y.
	y2 := anotherHG2dPoint y - y.
	^ x1 * y2 - (y1 * x2)
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint crossPoint: anotherFrom to: anotherTo [
	| min1 min2 max1 max2 x1 y1 x2 y2 x3 y3 x4 y4 t1 t2 t x0 y0 |
	min1 := x min: anHG2dPoint x.
	min2 := anotherFrom x min: anotherTo x.
	max1 := x max: anHG2dPoint x.
	max2 := anotherFrom x max: anotherTo x.
	(min1 > max2 or: [ max1 < min2 ])
		ifTrue: [ ^ nil ].
	min1 := y min: anHG2dPoint y.
	min2 := anotherFrom y min: anotherTo y.
	max1 := y max: anHG2dPoint y.
	max2 := anotherFrom y max: anotherTo y.
	(min1 > max2 or: [ max1 < min2 ])
		ifTrue: [ ^ nil ].
	x1 := x.
	y1 := y.
	x2 := anHG2dPoint x.
	y2 := anHG2dPoint y.
	x3 := anotherFrom x.
	y3 := anotherFrom y.
	x4 := anotherTo x.
	y4 := anotherTo y.
	t1 := (x1 - x3) * (y4 - y3) - ((x4 - x3) * (y1 - y3)).
	t2 := (x4 - x3) * (y2 - y1) - ((x2 - x1) * (y4 - y3)).
	t2 = 0.0 ifTrue: [^nil].
	t := t1 / t2.
	x0 := (x2 - x1) * t + x1.
	y0 := (y2 - y1) * t + y1.
	^ (x0 >= (x1 min: x2) and: [ x0 <= (x1 max: x2) ])
		ifTrue: [ HG2dPoint x: x0 y: y0 ]
		ifFalse: [ nil ]
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint crossPointX: aNumber [
	(x max: anHG2dPoint x) < aNumber
		ifTrue: [ ^ nil ].
	(x min: anHG2dPoint x) > aNumber
		ifTrue: [ ^ nil ].
	^ self class x: aNumber y: (anHG2dPoint y - y) * (aNumber - x) / (anHG2dPoint x - x) + y
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint crossPointY: aNumber [
	(y max: anHG2dPoint y) < aNumber
		ifTrue: [ ^ nil ].
	(y min: anHG2dPoint y) > aNumber
		ifTrue: [ ^ nil ].
	^ self class x: (anHG2dPoint x - x) * (aNumber - y) / (anHG2dPoint y - y) + x y: aNumber
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint distance: anotherHG2dPoint [
	^ (self to: anHG2dPoint nearestFrom: anotherHG2dPoint) distance: anotherHG2dPoint 
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint dot: anotherHG2dPoint [
	| x1 x2 y1 y2 |
	x1 := anHG2dPoint x - x.
	x2 := anotherHG2dPoint x - x.
	y1 := anHG2dPoint y - y.
	y2 := anotherHG2dPoint y - y.
	^ x1 * x2 + (y1 * y2)
]

{ #category : #vector }
HG2dPoint >> to: anHG2dPoint nearestFrom: anotherHG2dPoint [
	| distance |
	^ (distance := self distance: anHG2dPoint) < 1.0e-8
		ifTrue: [ self copy ]
		ifFalse: [ 
			(anHG2dPoint - self)
				* ((self to: anHG2dPoint dot: anotherHG2dPoint) / (self to: anHG2dPoint dot: anHG2dPoint) min: 1.0 max: 0.0) + self ]
]

{ #category : #vector }
HG2dPoint >> unitVector: aPoint [
	| vx vy denominator |
	vx := aPoint x - x.
	vy := aPoint y - y.
	denominator := (vx * vx + (vy * vy)) sqrt.
	denominator < 1.0e-20
		ifTrue: [ denominator := 1.0 ].
	^ self class x: vx / denominator y: vy / denominator
]

{ #category : #accessing }
HG2dPoint >> x [ 
	^x
]

{ #category : #accessing }
HG2dPoint >> x: aNumber [
	x := aNumber
]

{ #category : #accessing }
HG2dPoint >> y [ 
	^y
]

{ #category : #accessing }
HG2dPoint >> y: aNumber [
	y := aNumber
]
