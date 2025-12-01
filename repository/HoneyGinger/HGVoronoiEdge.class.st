Class {
	#name : 'HGVoronoiEdge',
	#superclass : 'Object',
	#instVars : [
		'foreside',
		'backside',
		'origin',
		'vector',
		'fromT',
		'toT'
	],
	#category : 'HoneyGinger-Geometry-Voronoi',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Voronoi'
}

{ #category : 'instance creation' }
HGVoronoiEdge class >> foreside: anHGVoronoiRegion1 backside: anHGVoronoiRegion2 [
	| x1 y1 x2 y2 originX originY vectorX vectorY |
	x1 := anHGVoronoiRegion1 center x.
	y1 := anHGVoronoiRegion1 center y.
	x2 := anHGVoronoiRegion2 center x.
	y2 := anHGVoronoiRegion2 center y.
	^ self
		foreside: anHGVoronoiRegion1
		backside: anHGVoronoiRegion2
		origin: (HG2dPoint x: (x1 + x2) / 2.0 y: (y1 + y2) / 2.0)
		vector: (HG2dPoint x: y2 - y1 y: x1 - x2)
]

{ #category : 'instance creation' }
HGVoronoiEdge class >> foreside: anHGVoronoiRegion1 backside: anHGVoronoiRegion2 origin: anHG2dPoint1 vector: anHG2dPoint2 [
	^ self foreside: anHGVoronoiRegion1  backside: anHGVoronoiRegion2 origin:  anHG2dPoint1 vector: anHG2dPoint2 fromT: Float infinity negated toT:  Float infinity 
]

{ #category : 'instance creation' }
HGVoronoiEdge class >> foreside: anHGVoronoiRegion1 backside: anHGVoronoiRegion2 origin: anHG2dPoint1 vector: anHG2dPoint2 fromT: aNumber1 toT: aNumber2 [
	^ (self new)
		foreside: anHGVoronoiRegion1;
		backside: anHGVoronoiRegion2;
		origin: anHG2dPoint1;
		vector: anHG2dPoint2;
		fromT: aNumber1;
		toT: aNumber2;
		yourself
]

{ #category : 'geometry' }
HGVoronoiEdge >> atT: aNumber [
	^ HG2dPoint x: vector x * aNumber + origin x y: vector y * aNumber + origin y
]

{ #category : 'accessing' }
HGVoronoiEdge >> backside [
	^ backside 
]

{ #category : 'accessing' }
HGVoronoiEdge >> backside: anHGVoronoiRegion [
	backside  := anHGVoronoiRegion 
]

{ #category : 'testing' }
HGVoronoiEdge >> containsT: aNumber [
	^ fromT <= aNumber and: [ aNumber <= toT ]
]

{ #category : 'testing' }
HGVoronoiEdge >> containsT: aNumber accuracy: anotherNumber [
	^ fromT - anotherNumber <= aNumber and: [ aNumber - anotherNumber <= toT ]
]

{ #category : 'accessing' }
HGVoronoiEdge >> foreside [
	^ foreside
]

{ #category : 'accessing' }
HGVoronoiEdge >> foreside: anHGVoronoiRegion [
	foreside := anHGVoronoiRegion 
]

{ #category : 'accessing' }
HGVoronoiEdge >> fromT [
	^ fromT
]

{ #category : 'accessing' }
HGVoronoiEdge >> fromT: aNumber [
	fromT := aNumber
]

{ #category : 'testing' }
HGVoronoiEdge >> isEmpty [
	^ fromT > toT
]

{ #category : 'testing' }
HGVoronoiEdge >> notEmpty [
	^ fromT <= toT
]

{ #category : 'topology' }
HGVoronoiEdge >> on: anHGVoronoiRegion cutAtT: aNumber byEdge: anHGVoronoiEdge [
	| center |
	center := anHGVoronoiRegion center.
	^ (fromT - aNumber) abs > (toT - aNumber) abs
		ifTrue: [ 
			| p |
			p := self
				atT:
					(fromT isInfinite
						ifTrue: [ aNumber - 100.0 ]
						ifFalse: [ (aNumber + fromT) / 2.0 ]).
			(anHGVoronoiEdge seesSameSide: center and: p)
				ifTrue: [ 
					(aNumber < toT
						ifTrue: [ toT := aNumber ]) notNil ]
				ifFalse: [ 
					(fromT < aNumber
						ifTrue: [ fromT := aNumber ]) notNil ] ]
		ifFalse: [ 
			| p |
			p := self
				atT:
					(toT isInfinite
						ifTrue: [ aNumber + 100.0 ]
						ifFalse: [ (aNumber + toT) / 2.0 ]).
			(anHGVoronoiEdge seesSameSide: center and: p) not
				ifTrue: [ 
					(aNumber < toT
						ifTrue: [ toT := aNumber ]) notNil ]
				ifFalse: [ 
					(fromT < aNumber
						ifTrue: [ fromT := aNumber ]) notNil ] ]
]

{ #category : 'topology' }
HGVoronoiEdge >> on: anHGVoronoiRegion cutByEdge: anHGVoronoiEdge ifParallel: aBlock [
	| a1 x1 b1 y1 a2 x2 b2 y2 det dx dy t1 t2 |
	a1 := vector x.
	x1 := origin x.
	b1 := vector y.
	y1 := origin y.
	a2 := anHGVoronoiEdge vector x.
	x2 := anHGVoronoiEdge origin x.
	b2 := anHGVoronoiEdge vector y.
	y2 := anHGVoronoiEdge origin y.
	det := a2 * b1 - (a1 * b2).
	det abs < 1.0e-8
		ifTrue: [ ^ aBlock value ].
	dx := x2 - x1.
	dy := y2 - y1.
	t1 := (a2 * dy - (b2 * dx)) / det.
	t2 := (a1 * dy - (b1 * dx)) / det.
	^ (((self containsT: t1 accuracy: 1.0e-8) and: [ anHGVoronoiEdge containsT: t2 accuracy: 1.0e-8 ])
		ifTrue: [ 
			self on: anHGVoronoiRegion cutAtT: t1 byEdge: anHGVoronoiEdge.
			anHGVoronoiEdge on: anHGVoronoiRegion cutAtT: t2 byEdge: self ]) notNil
]

{ #category : 'accessing' }
HGVoronoiEdge >> origin [
	^ origin
]

{ #category : 'accessing' }
HGVoronoiEdge >> origin: anHG2dPoint [
	origin := anHG2dPoint
]

{ #category : 'printing' }
HGVoronoiEdge >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	origin x printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	origin y printOn: aStream.
	aStream nextPutAll: '->'.
	vector x printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	vector y printOn: aStream.
	aStream nextPutAll: ' | '.
	fromT printOn: aStream.
	aStream nextPutAll: '->'.
	toT printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'topology' }
HGVoronoiEdge >> remove [
	foreside removeEdge: self.
	backside removeEdge: self
]

{ #category : 'testing' }
HGVoronoiEdge >> seesSameSide: anHG2dPoint1 and: anHG2dPoint2 [
	^ ((anHG2dPoint1 x - origin x) * vector y - ((anHG2dPoint1 y - origin y) * vector x)) < 0.0 xor: 
		((anHG2dPoint2 x - origin x) * vector y - ((anHG2dPoint2 y - origin y) * vector x)) > 0.0
]

{ #category : 'geometry' }
HGVoronoiEdge >> somePoint [
	^ self
		atT:
			(fromT isInfinite
				ifTrue: [ 
					toT isInfinite
						ifTrue: [ 0.0 ]
						ifFalse: [ toT - 100.0 ] ]
				ifFalse: [ 
					toT isInfinite
						ifTrue: [ fromT + 100.0 ]
						ifFalse: [ (fromT + toT) / 2.0 ] ])
]

{ #category : 'geometry' }
HGVoronoiEdge >> tAtX: aNumber [
	| t |
	vector x abs < 1.0e-8
		ifTrue: [ ^ nil ].
	t := (aNumber - origin x) / vector x.
	^ (self containsT: t)
		ifTrue: [ t ]
]

{ #category : 'geometry' }
HGVoronoiEdge >> tAtY: aNumber [
	| t |
	vector y abs < 1.0e-8
		ifTrue: [ ^ nil ].
	t := aNumber - origin y / vector y.
	^ (self containsT: t) ifTrue: [ t ]
]

{ #category : 'accessing' }
HGVoronoiEdge >> theOtherSide: anHGVoronoiRegion [
	anHGVoronoiRegion == foreside
		ifTrue: [ ^ backside ].
	anHGVoronoiRegion == backside
		ifTrue: [ ^ foreside ].
	^ nil
]

{ #category : 'accessing' }
HGVoronoiEdge >> toT [
	^ toT
]

{ #category : 'accessing' }
HGVoronoiEdge >> toT: aNumber [
	toT := aNumber
]

{ #category : 'accessing' }
HGVoronoiEdge >> vector [
	^ vector 
]

{ #category : 'accessing' }
HGVoronoiEdge >> vector: anHG2dPoint [
	vector := anHG2dPoint 
]
