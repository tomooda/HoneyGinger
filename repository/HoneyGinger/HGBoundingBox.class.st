Class {
	#name : #HGBoundingBox,
	#superclass : #HGAction,
	#instVars : [
		'reflectionRate'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #copyrights }
HGBoundingBox class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGBoundingBox class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGBoundingBox class >> reflectionRate: aNumber [
	^ self new setReflectionRate: aNumber
]

{ #category : #copyrights }
HGBoundingBox class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGBoundingBox >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
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
			position x: (position x - x0) * reflectionRate + x0.
			velocity x: velocity x * reflectionRate .
			changed := true ].
	position x > x1
		ifTrue: [ 
			position x: ( position x - x1)* reflectionRate + x1.
			velocity x: velocity x * reflectionRate.
			changed := true ].
	position y < y0
		ifTrue: [ 
			position y: (position y - y0) * reflectionRate + y0.
			velocity y: velocity y * reflectionRate.
			changed := true ].
	position y > y1
		ifTrue: [ 
			position y: (position y - y1) * reflectionRate + y1.
			velocity y: velocity y * reflectionRate.
			changed := true ].
	changed ] whileTrue
]

{ #category : #private }
HGBoundingBox >> setReflectionRate: aNumber [
	reflectionRate := aNumber abs negated
]
