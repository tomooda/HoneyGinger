Class {
	#name : #HGPerspectivePolygonVisualizer,
	#superclass : #HGPerspectiveTriangulatedVisualizer,
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #accessing }
HGPerspectivePolygonVisualizer >> color [
	^ color
]

{ #category : #accessing }
HGPerspectivePolygonVisualizer >> color: aColor [
	color := aColor
]

{ #category : #drawing }
HGPerspectivePolygonVisualizer >> drawTriangle: aPoint1 and: aPoint2 and: aPoint3 color: aColor on: aCanvas [
	aCanvas drawPolygon: (Array with: aPoint1 with: aPoint2 with: aPoint3) fillStyle: aColor
]
