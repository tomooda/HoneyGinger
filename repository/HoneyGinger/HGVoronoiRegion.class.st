Class {
	#name : 'HGVoronoiRegion',
	#superclass : 'Object',
	#instVars : [
		'center',
		'edges'
	],
	#category : 'HoneyGinger-Geometry-Voronoi',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Voronoi'
}

{ #category : 'instance creation' }
HGVoronoiRegion class >> at: anHG2dPoint [
	^ (self new)
		center: anHG2dPoint;
		yourself
]

{ #category : 'adding' }
HGVoronoiRegion >> addEdge: anHGVoronoiEdge [
	^ edges add: anHGVoronoiEdge 
]

{ #category : 'accessing' }
HGVoronoiRegion >> center [
	^ center
]

{ #category : 'accessing' }
HGVoronoiRegion >> center: anHG2dPoint [
	center := anHG2dPoint
]

{ #category : 'testing' }
HGVoronoiRegion >> containsPoint: anHG2dPoint [
	^ edges allSatisfy: [:edge |
		edge seesSameSide: center and: anHG2dPoint]
]

{ #category : 'topology' }
HGVoronoiRegion >> cutAgainst: anHGVoronoiRegion conflictEdgesDo: aBlock [
	| newEdge |
	newEdge := HGVoronoiEdge foreside: self backside: anHGVoronoiRegion.
	edges
		do: [ :edge | 
			(edge on: self cutByEdge: newEdge ifParallel: [ true ])
				ifTrue: [ aBlock value: newEdge value: edge ] ].
	self addEdge: newEdge.
	anHGVoronoiRegion addEdge: newEdge.
	^ newEdge
]

{ #category : 'topology' }
HGVoronoiRegion >> cutAgainst: anHGVoronoiRegion conflictEdgesDo: aBlock parallelEdgesDo: anotherBlock [
	| newEdge |
	newEdge := HGVoronoiEdge foreside: self backside: anHGVoronoiRegion.
	edges
		do: [ :edge | 
			(edge
				on: self
				cutByEdge: newEdge
				ifParallel: [ 
					anotherBlock value: newEdge value: edge.
					false ])
				ifTrue: [ aBlock value: newEdge value: edge ] ].
	self addEdge: newEdge.
	anHGVoronoiRegion addEdge: newEdge.
	^ newEdge
]

{ #category : 'enumerating' }
HGVoronoiRegion >> edgesDo: aBlock [
	edges do: aBlock
]

{ #category : 'initialize-release' }
HGVoronoiRegion >> initialize [
	super initialize.
	edges := OrderedCollection new
]

{ #category : 'enumerating' }
HGVoronoiRegion >> origin: aPoint1 corner: aPoint2 pointsDo: aBlock [

	| x1 x2 y1 y2 points |
	x1 := aPoint1 x.
	x2 := aPoint2 x.
	y1 := aPoint1 y.
	y2 := aPoint2 y.
	points := OrderedCollection new: edges size + 4.
	self edgesDo: [ :edge | 
		| from to |
		from := edge fromT.
		to := edge toT.
		(edge tAtX: x1) ifNotNil: [ :t | 
			edge vector x > 0.0
				ifTrue: [ from := from max: t ]
				ifFalse: [ to := to min: t ] ].
		(edge tAtY: y1) ifNotNil: [ :t | 
			edge vector y > 0.0
				ifTrue: [ from := from max: t ]
				ifFalse: [ to := to min: t ] ].
		(edge tAtX: x2) ifNotNil: [ :t | 
			edge vector x > 0.0
				ifTrue: [ to := to min: t ]
				ifFalse: [ from := from max: t ] ].
		(edge tAtY: y2) ifNotNil: [ :t | 
			edge vector y > 0.0
				ifTrue: [ to := to min: t ]
				ifFalse: [ from := from max: t ] ].
		(from <= to and: [ from isInfinite not and: [ to isInfinite not ] ]) 
			ifTrue: [ 
				| p1 p2 theta1 theta2 |
				p1 := edge atT: from.
				p2 := edge atT: to.
				theta1 := (p1 - center) theta.
				theta2 := (p2 - center) theta.
				edge fromT ~= from ifTrue: [ points add: theta1 -> p1 ].
				edge toT ~= to ifTrue: [ points add: theta2 -> p2 ].
				theta2 - theta1 \\ Float twoPi < Float pi
					ifTrue: [ 
					edge fromT isInfinite not ifTrue: [ points add: theta1 -> p1 ] ]
					ifFalse: [ 
					edge toT isInfinite not ifTrue: [ points add: theta2 -> p2 ] ] ] ].
	(HG2dPoint x: x1 y: y1) in: [ :point | 
		(self containsPoint: point) ifTrue: [ 
			points add: (point - center) theta -> point ] ].
	(HG2dPoint x: x1 y: y2) in: [ :point | 
		(self containsPoint: point) ifTrue: [ 
			points add: (point - center) theta -> point ] ].
	(HG2dPoint x: x2 y: y1) in: [ :point | 
		(self containsPoint: point) ifTrue: [ 
			points add: (point - center) theta -> point ] ].
	(HG2dPoint x: x2 y: y2) in: [ :point | 
		(self containsPoint: point) ifTrue: [ 
			points add: (point - center) theta -> point ] ].
	(points asSortedCollection: [ :less :more | less key <= more key ]) 
		do: [ :pair | aBlock value: pair value ]
]

{ #category : 'printing' }
HGVoronoiRegion >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	center x printOn: aStream.
	aStream nextPut: $,.
	aStream space.
	center y printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'topology' }
HGVoronoiRegion >> purgeExtraEdges [
	^ (edges
		select: [ :suspect | 
			| point |
			point := suspect somePoint.
			edges anySatisfy: [ :judge | suspect ~~ judge and: [(judge seesSameSide: center and: point) not] ] ])
		do: [ :edge | edge remove ];
		yourself
]

{ #category : 'removing' }
HGVoronoiRegion >> removeEdge: anHGVoronoiEdge [
	^ edges remove: anHGVoronoiEdge 
]
