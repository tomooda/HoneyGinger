Class {
	#name : 'HGSetupBindingElasticForce',
	#superclass : 'HGAction',
	#instVars : [
		'maxDistance',
		'elasticForceAction'
	],
	#category : 'HoneyGinger-Actions-Elasticity',
	#package : 'HoneyGinger',
	#tag : 'Actions-Elasticity'
}

{ #category : 'copyrights' }
HGSetupBindingElasticForce class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGSetupBindingElasticForce class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGSetupBindingElasticForce class >> on: anHGElasticForceAction within: aNumber [
	^ (self new)
		elasticForceAction: anHGElasticForceAction;
		maxDistance: aNumber;
		yourself
]

{ #category : 'copyrights' }
HGSetupBindingElasticForce class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGSetupBindingElasticForce >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [

]

{ #category : 'simulating' }
HGSetupBindingElasticForce >> effectIn: anHGSimulator deltaT: aNumber [
	| particles triangulator kernel |
	particles := IdentityDictionary new.
	triangulator := HGTriangulator
		origin: anHGSimulator simulationOrigin
		corner: anHGSimulator simulationCorner
		step: 80.
	anHGSimulator
		particlesDo: [ :particle | 
			triangulator divideAt: particle position.
			particles at: particle position put: particle ].
	triangulator
		trianglesDo: [ :triangle | 
			| particle1 particle2 particle3 |
			particle1 := particles at: triangle vertex1 ifAbsent: [  ].
			particle2 := particles at: triangle vertex2 ifAbsent: [  ].
			particle3 := particles at: triangle vertex3 ifAbsent: [  ].
			(particle1 notNil and: [ particle2 notNil and: [ (particle1 position distance: particle2 position) < maxDistance ] ])
				ifTrue: [ elasticForceAction addBindingBetween: particle1 and: particle2 ].
			(particle2 notNil and: [ particle3 notNil and: [ (particle2 position distance: particle3 position) < maxDistance ] ])
				ifTrue: [ elasticForceAction addBindingBetween: particle2 and: particle3 ].
			(particle3 notNil and: [ particle1 notNil and: [ (particle3 position distance: particle1 position) < maxDistance ] ])
				ifTrue: [ elasticForceAction addBindingBetween: particle3 and: particle1 ] ]
]

{ #category : 'accessing' }
HGSetupBindingElasticForce >> elasticForceAction [
	^ elasticForceAction
]

{ #category : 'accessing' }
HGSetupBindingElasticForce >> elasticForceAction: anHGElasticForceAction [
	elasticForceAction := anHGElasticForceAction 
]

{ #category : 'accessing' }
HGSetupBindingElasticForce >> maxDistance [
	^ maxDistance
]

{ #category : 'accessing' }
HGSetupBindingElasticForce >> maxDistance: aNumber [
	maxDistance := aNumber 
]
