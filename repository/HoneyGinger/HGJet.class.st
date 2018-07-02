Class {
	#name : #HGJet,
	#superclass : #HGAction,
	#instVars : [
		'region',
		'v'
	],
	#category : 'HoneyGinger-Actions-Mechanics'
}

{ #category : #'instance creation' }
HGJet class >> v: anHG2dPoint in: anHG2dRegion [
	^ (self new)
		v: anHG2dPoint;
		region: anHG2dRegion;
		yourself
]

{ #category : #drawing }
HGJet >> draw: anHGSimulator on: aCanvas [
	aCanvas frameOval: (self region origin asPoint corner: self region corner asPoint) color: Color black.
	aCanvas line: self region center asPoint to: (self region center + self v) asPoint width: 5 color: Color black
]

{ #category : #simulating }
HGJet >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	(region contains: anHGParticle position)
		ifTrue: [ 
			anHGParticle velocity: v copy.
			anHGParticle force: HG2dPoint zero.
			anHGParticle position: self region center copy ]
]

{ #category : #simulating }
HGJet >> effectIn: anHGSimulator deltaT: aNumber [
	super effectIn: anHGSimulator deltaT: aNumber .
	self draw: anHGSimulator on: anHGSimulator form getCanvas
]

{ #category : #accessing }
HGJet >> region [
	^ region
]

{ #category : #accessing }
HGJet >> region: anObject [
	region := anObject
]

{ #category : #accessing }
HGJet >> v [
	^ v
]

{ #category : #accessing }
HGJet >> v: anObject [
	v := anObject
]
