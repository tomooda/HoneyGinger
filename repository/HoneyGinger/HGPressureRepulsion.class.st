Class {
	#name : 'HGPressureRepulsion',
	#superclass : 'HGAction',
	#instVars : [
		'kernel',
		'maxPressure'
	],
	#category : 'HoneyGinger-Actions-FluidDynamics',
	#package : 'HoneyGinger',
	#tag : 'Actions-FluidDynamics'
}

{ #category : 'copyrights' }
HGPressureRepulsion class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGPressureRepulsion class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGPressureRepulsion class >> kernel: anHGKernel [
	^ self kernel: anHGKernel maxPressure: Float infinity
]

{ #category : 'instance creation' }
HGPressureRepulsion class >> kernel: anHGKernel maxPressure: aNumber [
	^ self new setKernel: anHGKernel maxPressure: aNumber
]

{ #category : 'copyrights' }
HGPressureRepulsion class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGPressureRepulsion >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| f denominator position area |
	denominator := 0.0.
	f := anHGParticle force class zero.
	position := anHGParticle position.
	area := anHGParticle area.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | 
			| gradient factor |
			gradient := kernel r: distance.
			factor := neighbor mass * area * gradient.
			f add: (neighbor position unitVector: position) by: (neighbor pressure * factor min: maxPressure max: maxPressure negated).
			denominator := denominator + gradient ].
	denominator > 0.0
		ifTrue: [ 
			anHGParticle addForce: f by: 1.0 / denominator]
]

{ #category : 'accessing' }
HGPressureRepulsion >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGPressureRepulsion >> maxPressure [
	^ maxPressure
]

{ #category : 'accessing' }
HGPressureRepulsion >> maxPressure: aNumber [
	maxPressure := aNumber
]

{ #category : 'private' }
HGPressureRepulsion >> setKernel: anHGKernel maxPressure: aNumber [
	kernel := anHGKernel.
	maxPressure := aNumber
]
