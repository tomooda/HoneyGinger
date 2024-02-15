Class {
	#name : 'HGPerspectiveWireframeVisualizer',
	#superclass : 'HGPerspectiveTriangulatedVisualizer',
	#instVars : [
		'width'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGPerspectiveWireframeVisualizer class >> width: aNumber color: aColor eyeHeight: height vanishingPoint: point depthBlock: simulatorAndParticleBlock [
	^ (self
		color: aColor
		eyeHeight: height
		vanishingPoint: point
		depthBlock: simulatorAndParticleBlock)
		width: aNumber;
		yourself
]

{ #category : 'drawing' }
HGPerspectiveWireframeVisualizer >> drawTriangle: aPoint1 and: aPoint2 and: aPoint3 color: aColor on: aCanvas [
	aCanvas
		line: aPoint1
		to: aPoint2
		width: width
		color: aColor.
	aCanvas
		line: aPoint2
		to: aPoint3
		width: width
		color: aColor.
	aCanvas
		line: aPoint3
		to: aPoint1
		width: width
		color: aColor
]

{ #category : 'accessing' }
HGPerspectiveWireframeVisualizer >> width [
	^ width
]

{ #category : 'accessing' }
HGPerspectiveWireframeVisualizer >> width: aNumber [
	width := aNumber
]
