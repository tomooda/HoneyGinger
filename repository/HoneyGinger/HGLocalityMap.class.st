Class {
	#name : #HGLocalityMap,
	#superclass : #HGAction,
	#instVars : [
		'rejectOutOfBounds'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #copyrights }
HGLocalityMap class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGLocalityMap class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGLocalityMap class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGLocalityMap class >> withOutOfBoundsRemoval [
	^ (self new)
		rejectOutOfBounds: true;
		yourself
]

{ #category : #simulating }
HGLocalityMap >> effectIn: anHGSimulator deltaT: aNumber [
	rejectOutOfBounds = true
		ifTrue: [ 
			| originX originY cornerX cornerY |
			originX := anHGSimulator simulationOrigin x.
			originY := anHGSimulator simulationOrigin y.
			cornerX := anHGSimulator simulationCorner x.
			cornerY := anHGSimulator simulationCorner y.
			anHGSimulator
				removeParticlesSuchThat: [ :particle | (particle position x between: originX and: cornerX) not or: [ (particle position y between: originY and: cornerY) not ] ] ]
		ifFalse: [ anHGSimulator updateParticleMap ]
]

{ #category : #'initialize-release' }
HGLocalityMap >> initialize [
	super initialize.
	rejectOutOfBounds := false
]

{ #category : #accessing }
HGLocalityMap >> rejectOutOfBounds [
	^ rejectOutOfBounds
]

{ #category : #accessing }
HGLocalityMap >> rejectOutOfBounds: aBoolean [
	rejectOutOfBounds := aBoolean = true
]
