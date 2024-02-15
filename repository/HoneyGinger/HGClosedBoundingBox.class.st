Class {
	#name : 'HGClosedBoundingBox',
	#superclass : 'HGAction',
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'copyrights' }
HGClosedBoundingBox class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGClosedBoundingBox class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGClosedBoundingBox class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGClosedBoundingBox >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| x0 y0 x1 y1 position velocity |
	x0 := anHGSimulator simulationOrigin x.
	y0 := anHGSimulator simulationOrigin y.
	x1 := anHGSimulator simulationCorner x.
	y1 := anHGSimulator simulationCorner y.
	position := anHGParticle position.
	velocity := anHGParticle velocity.
	[ 
	| changed |
	changed := false.
	position x < x0
		ifTrue: [ 
			position x: x1 - x0 + position x.
			changed := true ].
	position x > x1
		ifTrue: [ 
			position x: x0 - x1 + position x.
			changed := true ].
	position y < y0
		ifTrue: [ 
			position y: y1 - y0 + position y.
			changed := true ].
	position y > y1
		ifTrue: [ 
			position y: y0 - y1 + position y.
			changed := true ].
	changed ] whileTrue
]
