Class {
	#name : #HGCrusher,
	#superclass : #HGAction,
	#instVars : [
		'particleIndex',
		'elasticForce',
		'radius'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #copyrights }
HGCrusher class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGCrusher class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGCrusher class >> at: anInteger radius: aNumber against: anHGElasticTrindingForce [
	^ (self new)
		particleIndex: anInteger;
		radius: aNumber;
		elasticForce: anHGElasticTrindingForce;
		yourself
]

{ #category : #copyrights }
HGCrusher class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGCrusher >> effectIn: anHGSimulator deltaT: aNumber [
	elasticForce breakTrindingsAround: (anHGSimulator particleAt: particleIndex) position within:  radius
]

{ #category : #accessing }
HGCrusher >> elasticForce [ 
	^ elasticForce 
]

{ #category : #accessing }
HGCrusher >> elasticForce: anHGElasticForce [
	elasticForce := anHGElasticForce 
]

{ #category : #accessing }
HGCrusher >> particleIndex [ 
	^ particleIndex 
]

{ #category : #accessing }
HGCrusher >> particleIndex: anInteger [
	particleIndex := anInteger 
]

{ #category : #accessing }
HGCrusher >> radius [
	^ radius
]

{ #category : #accessing }
HGCrusher >> radius: aNumber [
	radius := aNumber
]
