Class {
	#name : #HGRandomPosition,
	#superclass : #HGAction,
	#instVars : [
		'origin',
		'corner',
		'random',
		'region'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #copyrights }
HGRandomPosition class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGRandomPosition class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGRandomPosition class >> origin: aPoint corner: anotherPoint [
	^ self origin: aPoint corner: anotherPoint region: nil
]

{ #category : #'instance creation' }
HGRandomPosition class >> origin: aPoint corner: anotherPoint region: anHG2dRegion [
	^ self new setOrigin: (HG2dPoint fromPoint: aPoint) corner: (HG2dPoint fromPoint: anotherPoint) region: anHG2dRegion
]

{ #category : #copyrights }
HGRandomPosition class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGRandomPosition >> corner [
	^corner
]

{ #category : #simulating }
HGRandomPosition >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	[ anHGParticle position: (origin class randomFrom: origin to: corner with: random) ]
		doWhileFalse: [ region isNil or: [ region contains: anHGParticle position ] ]
]

{ #category : #'initialize-release' }
HGRandomPosition >> initialize [
	super initialize.
	random := Random new
]

{ #category : #accessing }
HGRandomPosition >> origin [
	^origin
]

{ #category : #accessing }
HGRandomPosition >> region [
	^ region
]

{ #category : #private }
HGRandomPosition >> setOrigin: anHGPoint corner: anotherHGPoint region: anHG2dRegion [
	origin := anHGPoint.
	corner := anotherHGPoint.
	region := anHG2dRegion 
]

{ #category : #accessing }
HGRandomPosition >> width: aNumber [
	| delta |
	delta := aNumber - corner x + origin x.
	origin x: delta / -2.0 + origin x.
	corner x: delta / 2.0 + corner x.
]
