Class {
	#name : #HGAddTrindingElasticBody,
	#superclass : #HGAction,
	#instVars : [
		'region',
		'numberOfParticles',
		'mass',
		'elasticForceAction'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #copyrights }
HGAddTrindingElasticBody class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGAddTrindingElasticBody class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGAddTrindingElasticBody class >> on: anHGTrindingElasticForce region: anHG2dRegion numberOfParticles: anInteger mass: aNumber [
	^ (self new)
		elasticForceAction: anHGTrindingElasticForce;
		region: anHG2dRegion;
		numberOfParticles: anInteger;
		mass: aNumber;
		yourself
]

{ #category : #copyrights }
HGAddTrindingElasticBody class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGAddTrindingElasticBody >> effectIn: anHGSimulator deltaT: aNumber [
	| random particles triangulator kernel |
	random := Random new.
	particles := IdentityDictionary new.
	triangulator := HGTriangulator
		origin: anHGSimulator simulationOrigin
		corner: anHGSimulator simulationCorner
		step: 80.
	numberOfParticles
		timesRepeat: [ 
			| position particle |
			[ 
			position := region origin class randomFrom: region origin to: region corner with: random.
			region contains: position ] whileFalse.
			particle := anHGSimulator addParticleAt: position temperature: 390 mass: mass.
			particle at: #radius put: 0.
			triangulator divideAt: particle position.
			particles at: particle position put: particle ].
	triangulator
		trianglesDo: [ :triangle | 
			| particle1 particle2 particle3 |
			particle1 := particles at: triangle vertex1 ifAbsent: [  ].
			particle2 := particles at: triangle vertex2 ifAbsent: [  ].
			particle3 := particles at: triangle vertex3 ifAbsent: [  ].
			(particle1 notNil and: [ particle2 notNil and: [ particle3 notNil ] ])
				ifTrue: [ elasticForceAction addTrindingAmong: particle1 and: particle2 and: particle3 ] ]
]

{ #category : #accessing }
HGAddTrindingElasticBody >> elasticForceAction [
	^ elasticForceAction
]

{ #category : #accessing }
HGAddTrindingElasticBody >> elasticForceAction: anHGElasticForceAction [
	elasticForceAction := anHGElasticForceAction 
]

{ #category : #accessing }
HGAddTrindingElasticBody >> mass [
	^ mass
]

{ #category : #accessing }
HGAddTrindingElasticBody >> mass: aNumber [
	mass := aNumber
]

{ #category : #accessing }
HGAddTrindingElasticBody >> numberOfParticles [
	^ numberOfParticles 
]

{ #category : #accessing }
HGAddTrindingElasticBody >> numberOfParticles: aNumber [
	numberOfParticles := aNumber 
]

{ #category : #accessing }
HGAddTrindingElasticBody >> region [
	^ region
]

{ #category : #accessing }
HGAddTrindingElasticBody >> region: anHG2dRegion [
	region := anHG2dRegion
]
