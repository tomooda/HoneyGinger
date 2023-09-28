Class {
	#name : 'HGStudsVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'offsetRadiusColors'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGStudsVisualizer class >> offset: aPoint radius: aNumber color: aColor [
	^ self new setOffsetRadiusColors: (Array with: (Array with: aPoint with: aNumber with: aColor))
]

{ #category : 'instance creation' }
HGStudsVisualizer class >> offset: aPoint1 radius: aNumber1 color: aColor1 offset: aPoint2 radius: aNumber2 color: aColor2 [
	^ self new
		setOffsetRadiusColors:
			(Array with: (Array with: aPoint1 with: aNumber1 with: aColor1) with: (Array with: aPoint2 with: aNumber2 with: aColor2))
]

{ #category : 'instance creation' }
HGStudsVisualizer class >> offset: aPoint1 radius: aNumber1 color: aColor1 offset: aPoint2 radius: aNumber2 color: aColor2 offset: aPoint3 radius: aNumber3 color: aColor3 [
	^ self new
		setOffsetRadiusColors:
			(Array
				with: (Array with: aPoint1 with: aNumber1 with: aColor1)
				with: (Array with: aPoint2 with: aNumber2 with: aColor2)
				with: (Array with: aPoint3 with: aNumber3 with: aColor3))
]

{ #category : 'adding' }
HGStudsVisualizer >> addOffset: aPoint radius: aNumber color: aColor [
	offsetRadiusColors := offsetRadiusColors copyWith: (Array with: aPoint with: aNumber with: aColor)
]

{ #category : 'drawing' }
HGStudsVisualizer >> draw: anHGSimulator on: aCanvas [
	offsetRadiusColors
		do: [ :spec | 
			| offsetX offsetY radius color |
			offsetX := (spec at: 1) x.
			offsetY := (spec at: 1) y.
			radius := spec at: 2.
			color := spec at: 3.
			anHGSimulator
				particlesDo: [ :particle | 
					| p form |
					p := particle position.
					p
						ifNotNil: [ aCanvas fillOval: ((p x - radius + offsetX) @ (p y - radius + offsetY) extent: 2 @ 2 * radius) color: color ] ] ]
]

{ #category : 'initialize-release' }
HGStudsVisualizer >> initialize [
	offsetRadiusColors := Array new
]

{ #category : 'accessing' }
HGStudsVisualizer >> offset: aPoint radius: aNumber color: aColor [
	self setOffsetRadiusColors: (Array with: (Array with: aPoint with: aNumber with: aColor))
]

{ #category : 'accessing' }
HGStudsVisualizer >> offset: aPoint1 radius: aNumber1 color: aColor1 offset: aPoint2 radius: aNumber2 color: aColor2 [
	self
		setOffsetRadiusColors:
			(Array with: (Array with: aPoint1 with: aNumber1 with: aColor1) with: (Array with: aPoint2 with: aNumber2 with: aColor2))
]

{ #category : 'accessing' }
HGStudsVisualizer >> offset: aPoint1 radius: aNumber1 color: aColor1 offset: aPoint2 radius: aNumber2 color: aColor2 offset: aPoint3 radius: aNumber3 color: aColor3 [
	self
		setOffsetRadiusColors:
			(Array
				with: (Array with: aPoint1 with: aNumber1 with: aColor1)
				with: (Array with: aPoint2 with: aNumber2 with: aColor2)
				with: (Array with: aPoint3 with: aNumber3 with: aColor3))
]

{ #category : 'private' }
HGStudsVisualizer >> setOffsetRadiusColors: anArray [
	offsetRadiusColors := anArray copy
]
