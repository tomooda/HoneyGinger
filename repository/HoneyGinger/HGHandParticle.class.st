Class {
	#name : #HGHandParticle,
	#superclass : #HGAction,
	#instVars : [
		'particleIndex',
		'lastPosition'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGHandParticle class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGHandParticle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGHandParticle class >> at: anInteger [
	^ self new particleIndex: anInteger
]

{ #category : #copyrights }
HGHandParticle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGHandParticle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
]

{ #category : #simulating }
HGHandParticle >> effectIn: anHGSimulator deltaT: aNumber [
	| bounds globalPoint position |
	bounds := anHGSimulator bounds.
	globalPoint := ActiveHand position.
	position := globalPoint - bounds origin.
	lastPosition ifNil: [lastPosition := position].
	(ActiveHand anyButtonPressed and: [ bounds containsPoint: globalPoint ])
		ifTrue: [ 
			self
				in: anHGSimulator
				particlesDo: [ :particle | 
					particle position set: position.
					particle velocity set: (position - lastPosition) / aNumber ] ].
	lastPosition := position
]

{ #category : #accessing }
HGHandParticle >> in: anHGSimulator particlesDo: aBlock [
	(anHGSimulator particleAt: particleIndex) ifNotNil: aBlock
]

{ #category : #accessing }
HGHandParticle >> particleIndex [
	^particleIndex
]

{ #category : #accessing }
HGHandParticle >> particleIndex: anInteger [
	particleIndex := anInteger
]
