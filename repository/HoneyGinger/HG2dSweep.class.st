Class {
	#name : 'HG2dSweep',
	#superclass : 'HG2dRegion',
	#instVars : [
		'from',
		'to',
		'radius'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'instance creation' }
HG2dSweep class >> from: anHG2dPoint1 to: anHG2dPoint2 radius: aNumber [
	^ self new setFrom: anHG2dPoint1 to: anHG2dPoint2 radius: aNumber
]

{ #category : 'accessing' }
HG2dSweep >> area [
	^ Float pi * radius * radius + (radius * (from distance: to) * 2.0)
]

{ #category : 'accessing' }
HG2dSweep >> borderAt: anHG2dPoint [
	| base |
	base := from to: to nearestFrom: anHG2dPoint.
	^ base plus: (base unitVector: anHG2dPoint) by: radius
]

{ #category : 'accessing' }
HG2dSweep >> center [
	^ HG2dPoint x: (from x + to x) / 2.0 y: (from y + to y) / 2.0
]

{ #category : 'accessing' }
HG2dSweep >> center: anHG2dPoint [
	| vx vy |
	vx := anHG2dPoint x - (from x + to x / 2.0).
	vy := anHG2dPoint y - (from y + to y / 2.0).
	from := HG2dPoint x: from x + vx y: from y + vy.
	to := HG2dPoint x: to x + vx y: to y + vy.
	self updateBounds
]

{ #category : 'testing' }
HG2dSweep >> conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint [
	^ (from to: to conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint)
		or: [ 
			(from to: to distance: anHG2dPoint) <= radius
				or: [ 
					(from to: to distance: anotherHG2dPoint) <= radius
						or: [ 
							(anHG2dPoint to: anotherHG2dPoint distance: from) <= radius
								or: [ (anHG2dPoint to: anotherHG2dPoint distance: to) <= radius ] ] ] ]
]

{ #category : 'testing' }
HG2dSweep >> contains: anHG2dPoint [
	^ (bounds contains: anHG2dPoint) and: [(from to: to distance: anHG2dPoint) <= radius]
]

{ #category : 'accessing' }
HG2dSweep >> depth: anHG2dPoint [
	^ radius - (from to: to nearestFrom: anHG2dPoint) max: 0.0
]

{ #category : 'accessing' }
HG2dSweep >> distance: anHG2dPoint [
	^ (from to: to nearestFrom: anHG2dPoint) - radius max: 0.0
]

{ #category : 'drawing' }
HG2dSweep >> drawOn: aCanvas color: aColor [
	aCanvas
		line: from asPoint
		to: to asPoint
		width: radius * 2
		color: aColor
]

{ #category : 'accessing' }
HG2dSweep >> from [
	^ from
]

{ #category : 'accessing' }
HG2dSweep >> from: anHG2dPoint [
	from := anHG2dPoint.
	self updateBounds
]

{ #category : 'accessing' }
HG2dSweep >> from: anHG2dPoint1 to: anHG2dPoint2 [
	from := anHG2dPoint1.
	to := anHG2dPoint2.
	self updateBounds
]

{ #category : 'accessing' }
HG2dSweep >> normAt: anHG2dPoint [
	| base |
	base := from to: to nearestFrom: anHG2dPoint.
	^ base unitVector: anHG2dPoint
]

{ #category : 'printing' }
HG2dSweep >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	from printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	to printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	radius printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
HG2dSweep >> radius [
	^ radius
]

{ #category : 'accessing' }
HG2dSweep >> radius:  aNumber [
	radius := aNumber.
	self updateBounds
]

{ #category : 'private' }
HG2dSweep >> setFrom: anHG2dPoint1 to: anHG2dPoint2 radius: aNumber [
	from := anHG2dPoint1.
	to := anHG2dPoint2.
	radius := aNumber.
	self updateBounds
]

{ #category : 'accessing' }
HG2dSweep >> to [
	^ to
]

{ #category : 'accessing' }
HG2dSweep >> to: anHG2dPoint [
	to := anHG2dPoint.
	self updateBounds
]

{ #category : 'private' }
HG2dSweep >> updateBounds [
	bounds := HG2dRectangle
		originX: (from x min: to x) - radius
		originY: (from y min: from y) - radius
		cornerX: (from x max: to x) + radius
		cornerY: (from y max: to y) + radius
]
