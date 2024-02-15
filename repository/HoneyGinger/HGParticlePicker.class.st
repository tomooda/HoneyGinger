Class {
	#name : 'HGParticlePicker',
	#superclass : 'HGAction',
	#instVars : [
		'pickedParticle',
		'lastPosition'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGParticlePicker class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGParticlePicker class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGParticlePicker class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGParticlePicker >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
]

{ #category : 'simulating' }
HGParticlePicker >> effectIn: anHGSimulator deltaT: aNumber [
	| bounds globalPoint position oldPosition currentParticle |
	bounds := anHGSimulator bounds.
	globalPoint := World activeHand position.
	position := globalPoint - bounds origin.
	lastPosition ifNil: [ lastPosition := position ].
	oldPosition := nil.
	currentParticle := nil.
	(World activeHand anyButtonPressed and: [ bounds containsPoint: globalPoint ])
		ifTrue: [ 
			pickedParticle ifNil: [ self pickParticleAt: (HG2dPoint fromPoint: position) in: anHGSimulator ].
			pickedParticle
				ifNotNil: [ 
					pickedParticle position set: position.
					pickedParticle velocity set: (position - lastPosition) / aNumber.
					oldPosition := position.
					currentParticle := pickedParticle ] ].
	lastPosition := oldPosition.
	pickedParticle := currentParticle
]

{ #category : 'enumerating' }
HGParticlePicker >> in: anHGSimulator particlesDo: aBlock [

	pickedParticle ifNotNil: aBlock
]

{ #category : 'accessing' }
HGParticlePicker >> pickParticleAt: anHG2dPoint in: anHGSimulator [
	| nearest minDistance |
	nearest := nil.
	minDistance := Float infinity.
	anHGSimulator
		neighborsOf: anHG2dPoint
		within: 10.0
		do: [ :particle :distance | 
			distance < minDistance
				ifTrue: [ 
					minDistance := distance.
					nearest := particle ] ].
	^ pickedParticle := nearest
]

{ #category : 'accessing' }
HGParticlePicker >> pickedParticle [ 
	^ pickedParticle 
]

{ #category : 'accessing' }
HGParticlePicker >> pickedParticle: anHGParticle [
	pickedParticle := anHGParticle 
]
