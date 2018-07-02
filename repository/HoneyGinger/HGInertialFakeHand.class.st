Class {
	#name : #HGInertialFakeHand,
	#superclass : #HGAbstractFakeHand,
	#instVars : [
		'dumpingRate'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGInertialFakeHand class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGInertialFakeHand class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGInertialFakeHand class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGInertialFakeHand >> dumpingRate [
	^ dumpingRate
]

{ #category : #accessing }
HGInertialFakeHand >> dumpingRate: aNumber [
	dumpingRate := aNumber
]

{ #category : #simulating }
HGInertialFakeHand >> effectIn: anHGSimulator deltaT: aNumber [
	| bounds globalPoint position canvas |
	bounds := anHGSimulator bounds.
	globalPoint := ActiveHand position.
	ActiveHand
		showTemporaryCursor:
			((anHGSimulator bounds containsPoint: globalPoint)
				ifTrue: [ cursor ]
				ifFalse: [ Cursor normal ]).
	position := globalPoint - bounds origin.
	canvas := anHGSimulator form getCanvas.
	lastPosition
		ifNotNil: [ 
			(self collidesIn: anHGSimulator)
				ifFalse: [ 
					| deltaPosition |
					deltaPosition := position - lastPosition.
					self
						in: anHGSimulator
						particlesDo: [ :particle | 
							"particle velocity mul: dumpingRate.
							particle velocity add: deltaPosition by: mickey / aNumber"
							particle addPosition: deltaPosition by: mickey.
							particle velocity setX: 0.0 y: 0.0 ] ] ].
	self
		in: anHGSimulator
		particlesDo: [ :particle | 
			canvas
				translucentImage: image
				at: (particle position x - (image width // 2)) @ (particle position y - (image height // 2)) ].
	lastPosition := position
]

{ #category : #'initialize-release' }
HGInertialFakeHand >> initialize [
	super initialize.
	dumpingRate := 0.5
]
