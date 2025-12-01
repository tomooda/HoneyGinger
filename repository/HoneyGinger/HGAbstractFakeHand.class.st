Class {
	#name : 'HGAbstractFakeHand',
	#superclass : 'HGAction',
	#instVars : [
		'particleIndex',
		'lastPosition',
		'lastDelta',
		'mickey',
		'image',
		'cursor'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGAbstractFakeHand class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGAbstractFakeHand class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGAbstractFakeHand class >> at: anInteger image: aForm [
	^ self at: anInteger mickey: 1.0 image: aForm cursor: self dot
]

{ #category : 'instance creation' }
HGAbstractFakeHand class >> at: anInteger image: aForm cursor: anotherForm [
	^ self at: anInteger mickey: 1.0 image: aForm cursor: anotherForm
]

{ #category : 'instance creation' }
HGAbstractFakeHand class >> at: anInteger mickey: aNumber image: aForm [
	^ self
		at: anInteger
		mickey: aNumber
		image: aForm
		cursor: self dot
]

{ #category : 'instance creation' }
HGAbstractFakeHand class >> at: anInteger mickey: aNumber image: aForm cursor: anotherForm [
	^ (self new)
		particleIndex: anInteger;
		mickey: aNumber;
		image: aForm;
		cursor: anotherForm;
		yourself
]

{ #category : 'cursors' }
HGAbstractFakeHand class >> circle: radius [
	^self circle: radius color: Color black
]

{ #category : 'cursors' }
HGAbstractFakeHand class >> circle: radius color: aColor [
	| form |
	form := Form extent: radius @ radius * 2 depth: 32.
	(form getCanvas)
		fillColor: Color transparent;
		fillOval: (0 @ 0 extent: radius @ radius * 2) color: aColor;
		flush.
	^ form
]

{ #category : 'cursors' }
HGAbstractFakeHand class >> dot [
	| form |
	form := Form extent: 1 @ 1 depth: 32.
	(form getCanvas)
		fillColor: Color black;
		flush.
	^ form
]

{ #category : 'copyrights' }
HGAbstractFakeHand class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'testing' }
HGAbstractFakeHand >> collidesIn: anHGSimulator [
	| me radius |
	me := anHGSimulator particleAt: particleIndex.
	radius := image width max: image height.
	anHGSimulator
		neighborsOf: me position
		within: radius
		do: [ :particle :distance | 
			particle ~~ me
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : 'accessing' }
HGAbstractFakeHand >> cursor [
	^ cursor
]

{ #category : 'accessing' }
HGAbstractFakeHand >> cursor: aForm [
	cursor := aForm
]

{ #category : 'simulating' }
HGAbstractFakeHand >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
]

{ #category : 'simulating' }
HGAbstractFakeHand >> effectIn: anHGSimulator deltaT: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
HGAbstractFakeHand >> image [
	^ image
]

{ #category : 'accessing' }
HGAbstractFakeHand >> image: aForm [
	image := aForm
]

{ #category : 'evaluating' }
HGAbstractFakeHand >> in: anHGSimulator motionLineDo: aBlock [

	^ lastPosition ifNotNil: [ :p1 | 
		  (anHGSimulator particleAt: particleIndex) ifNotNil: [ :particle | 
			  aBlock value: p1 value: particle position ] ]
]

{ #category : 'accessing' }
HGAbstractFakeHand >> in: anHGSimulator particlesDo: aBlock [
	(anHGSimulator particleAt: particleIndex) ifNotNil: aBlock
]

{ #category : 'accessing' }
HGAbstractFakeHand >> mickey [
	^ mickey
]

{ #category : 'accessing' }
HGAbstractFakeHand >> mickey: aNumber [
	mickey := aNumber
]

{ #category : 'accessing' }
HGAbstractFakeHand >> particleIndex [
	^ particleIndex
]

{ #category : 'accessing' }
HGAbstractFakeHand >> particleIndex: anInteger [
	particleIndex := anInteger 
]
