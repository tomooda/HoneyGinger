Class {
	#name : 'HGNewtonianCooling',
	#superclass : 'HGAction',
	#instVars : [
		'kernel'
	],
	#category : 'HoneyGinger-Actions-Thermal',
	#package : 'HoneyGinger',
	#tag : 'Actions-Thermal'
}

{ #category : 'copyrights' }
HGNewtonianCooling class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGNewtonianCooling class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGNewtonianCooling class >> kernel: anHGKernel [
	^ self new setKernel: anHGKernel   
]

{ #category : 'copyrights' }
HGNewtonianCooling class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGNewtonianCooling >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
]

{ #category : 'simulating' }
HGNewtonianCooling >> effectIn: anHGSimulator deltaT: aNumber [
	anHGSimulator particlesDo: [ :particle | self stage1: particle in: anHGSimulator deltaT: aNumber ].
	anHGSimulator particlesDo: [ :particle | self stage2: particle in: anHGSimulator deltaT: aNumber ].
	anHGSimulator particlesDo: [ :particle | self stage3: particle in: anHGSimulator deltaT: aNumber ]
]

{ #category : 'private' }
HGNewtonianCooling >> setKernel: anHGKernel [
	kernel := anHGKernel 
]

{ #category : 'simulating' }
HGNewtonianCooling >> stage1: anHGParticle in: anHGSimulator deltaT: aNumber [
	anHGParticle heat: 0.0
]

{ #category : 'simulating' }
HGNewtonianCooling >> stage2: anHGParticle in: anHGSimulator deltaT: aNumber [
	| c |
	c := anHGParticle heatConductivity * anHGParticle area / anHGParticle heatCapacity * aNumber negated.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | anHGParticle addHeat: neighbor temperature - anHGParticle temperature by: anHGParticle heatCapacity * (c exp - 1) ]
]

{ #category : 'simulating' }
HGNewtonianCooling >> stage3: anHGParticle in: anHGSimulator deltaT: aNumber [
	anHGParticle addTemperature: anHGParticle heat by: 1.0 / anHGParticle heatCapacity
]
