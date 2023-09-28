Class {
	#name : 'HGViscosityTraction',
	#superclass : 'HGAction',
	#instVars : [
		'kernel'
	],
	#category : 'HoneyGinger-Actions-FluidDynamics',
	#package : 'HoneyGinger',
	#tag : 'Actions-FluidDynamics'
}

{ #category : 'copyrights' }
HGViscosityTraction class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGViscosityTraction class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGViscosityTraction class >> kernel: anHGKernel [
	^ (self new)
		setKernel: anHGKernel;
		yourself
]

{ #category : 'copyrights' }
HGViscosityTraction class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGViscosityTraction >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| f denominator area viscosity velocity |
	denominator := 0.0.
	f := anHGParticle force class zero.
	area := anHGParticle area.
	viscosity := anHGParticle viscosity.
	velocity := anHGParticle velocity.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | 
			neighbor ~~ anHGParticle
				ifTrue: [ 
					| gradient |
					gradient := kernel r: distance.
					f
						add: neighbor velocity
						minus: velocity
						by: ((viscosity + neighbor viscosity) / (distance + 1.0e-8) * area min: anHGParticle mass / aNumber) * gradient.
					denominator := denominator + gradient ] ].
	denominator = 0.0
		ifTrue: [ denominator := 1.0 ].
	anHGParticle addForce: f over: denominator
]

{ #category : 'private' }
HGViscosityTraction >> setKernel: anHGKernel [
	kernel := anHGKernel
]
