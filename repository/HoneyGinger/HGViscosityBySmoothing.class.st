Class {
	#name : #HGViscosityBySmoothing,
	#superclass : #HGAction,
	#instVars : [
		'kernel',
		'changes'
	],
	#category : 'HoneyGinger-Actions-FluidDynamics'
}

{ #category : #copyrights }
HGViscosityBySmoothing class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGViscosityBySmoothing class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGViscosityBySmoothing class >> kernel: anHGKernel [
	^ (self new)
		kernel: anHGKernel;
		yourself
]

{ #category : #copyrights }
HGViscosityBySmoothing class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGViscosityBySmoothing >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| denominator velocity |
	denominator := 0.0.
	velocity := anHGParticle force class zero.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | 
			neighbor ~~ anHGParticle
				ifTrue: [ 
					| gradient |
					gradient := (kernel r: distance) * neighbor viscosity.
					velocity add: neighbor velocity by: gradient.
					denominator := denominator + gradient ] ].
	denominator > 0.0
		ifTrue: [ 
			| viscosity |
			viscosity := anHGParticle viscosity.
			velocity mul: viscosity / denominator.
			velocity add: anHGParticle velocity by: 1.0 - viscosity.
			changes add: anHGParticle -> velocity ]
]

{ #category : #simulating }
HGViscosityBySmoothing >> effectIn: anHGSimulator deltaT: aNumber [
	changes := OrderedCollection new: anHGSimulator numberOfParticles.
	super effectIn: anHGSimulator deltaT: aNumber.
	changes do: [ :atomic | atomic key velocity: atomic value ].
	changes := nil
]

{ #category : #simulating }
HGViscosityBySmoothing >> kernel [
	^ kernel
]

{ #category : #private }
HGViscosityBySmoothing >> kernel: anHGKernel [
	kernel := anHGKernel
]
