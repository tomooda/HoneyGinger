Class {
	#name : #HGParticleGripper,
	#superclass : #HGAction,
	#instVars : [
		'offsets',
		'radius',
		'lastPosition'
	],
	#category : #'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGParticleGripper class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGParticleGripper class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGParticleGripper class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGParticleGripper class >> within: aNumber [
	^ (self new)
		radius: aNumber;
		yourself
]

{ #category : #simulating }
HGParticleGripper >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
]

{ #category : #simulating }
HGParticleGripper >> effectIn: anHGSimulator deltaT: aNumber [
	| bounds globalPoint position oldPosition currentParticle |
	bounds := anHGSimulator bounds.
	globalPoint := World activeHand position.
	position := HG2dPoint fromPoint: globalPoint - bounds origin.
	lastPosition ifNil: [ lastPosition := position ].
	oldPosition := nil.
	currentParticle := nil.
	(World activeHand anyButtonPressed and: [ bounds containsPoint: globalPoint ])
		ifTrue: [ 
			offsets
				ifNil: [ 
					offsets := IdentityDictionary new.
					anHGSimulator
						neighborsOf: position
						within: radius
						do: [ :particle :distance | offsets at: particle put: particle position - position ] ].
			offsets
				keysAndValuesDo: [ :particle :offset | 
					particle position: position + offset.
					particle velocity: (position - lastPosition) / aNumber.
					oldPosition := position ] ]
		ifFalse: [ offsets := nil ].
	lastPosition := oldPosition
]

{ #category : #enumerating }
HGParticleGripper >> in: anHGSimulator particlesDo: aBlock [
	offsets ifNotNil: [ :dict | dict keysDo: aBlock ]
]

{ #category : #accessing }
HGParticleGripper >> radius [
	^ radius
]

{ #category : #accessing }
HGParticleGripper >> radius: aNumber [
	radius := aNumber
]
