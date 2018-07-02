Class {
	#name : #HGVoronoiEdgeTest,
	#superclass : #HGTestCase,
	#category : 'HoneyGinger-Geometry-Tests'
}

{ #category : #tests }
HGVoronoiEdgeTest >> testForesideBackside1 [
	"tests if the HGVoronoiEdge class can create a line between the given two regions."

	| point1 point2 foreside backside edge |
	point1 := HG2dPoint x: 1.0 y: 2.0.
	point2 := HG2dPoint x: 3.0 y: 5.0.
	foreside := HGVoronoiRegion at: point1.
	backside := HGVoronoiRegion at: point2.
	edge := HGVoronoiEdge foreside: foreside backside: backside.
	-2.0 to: 2.0 by: 0.1 do: [ :t | 
		| point |
		point := edge atT: t.
		self assert: (point distance: point1) equals: (point distance: point2) accuracy: 0.01 ]
]
