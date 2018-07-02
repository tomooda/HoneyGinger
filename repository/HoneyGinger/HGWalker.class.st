Class {
	#name : #HGWalker,
	#superclass : #Morph,
	#instVars : [
		'v',
		'w'
	],
	#category : 'HoneyGinger-Utilities'
}

{ #category : #utility }
HGWalker class >> atHand [
	"HGWalker atHand"
	| walker |
	walker := self v: (Point r: 30.0 degrees: (World topLeft - ActiveHand center) degrees) w: 0.05.
	walker center: ActiveHand position.
	walker extent: 50@30.
	walker openInWorld
]

{ #category : #'instance creation' }
HGWalker class >> v: aPoint w: aNumber [
	^ self new setV: aPoint w: aNumber
]

{ #category : #private }
HGWalker >> setV: aPoint w: aNumber [
	v := aPoint.
	w := aNumber
]

{ #category : #'stepping and presenter' }
HGWalker >> step [
	v := Point r: v r degrees: v theta + w * 180.0 / Float pi.
	self position: self position + v.
	(World containsPoint: self center) ifFalse: [self delete]
]

{ #category : #'stepping and presenter' }
HGWalker >> stepTime [
	^ 20
]
