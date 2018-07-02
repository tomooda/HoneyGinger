Class {
	#name : #HGMaxVelocity,
	#superclass : #HGAction,
	#instVars : [
		'maxVelocity'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #copyrights }
HGMaxVelocity class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGMaxVelocity class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGMaxVelocity class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGMaxVelocity class >> within: aNumber [
	^ self new setMaxVelocity: aNumber  
]

{ #category : #simulating }
HGMaxVelocity >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| speed |
	(speed := anHGParticle velocity norm2) > maxVelocity 
		ifTrue: [ anHGParticle velocity: anHGParticle velocity / (speed / maxVelocity) ]
]

{ #category : #accessing }
HGMaxVelocity >> maxVelocity [
	^ maxVelocity
]

{ #category : #accessing }
HGMaxVelocity >> maxVelocity: aNumber [
	maxVelocity := aNumber
]

{ #category : #private }
HGMaxVelocity >> setMaxVelocity: aNumber [
	maxVelocity := aNumber
]
