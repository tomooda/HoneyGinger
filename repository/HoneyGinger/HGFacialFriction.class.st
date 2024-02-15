Class {
	#name : 'HGFacialFriction',
	#superclass : 'HGAction',
	#instVars : [
		'mu',
		'viscuss'
	],
	#category : 'HoneyGinger-Actions-Mechanics',
	#package : 'HoneyGinger',
	#tag : 'Actions-Mechanics'
}

{ #category : 'copyrights' }
HGFacialFriction class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGFacialFriction class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGFacialFriction class >> mu: aNumber [
	^ (self new)
		mu: aNumber;
		yourself
]

{ #category : 'instance creation' }
HGFacialFriction class >> mu: aNumber viscuss: aBoolean [
	^ (self new)
		mu: aNumber;
		viscuss: aBoolean;
		yourself
]

{ #category : 'simulating' }
HGFacialFriction >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| m v v0 |
	m := anHGParticle mass.
	v := anHGParticle velocity.
	v0 := v norm2.
	v0 > 1.0e-8
		ifTrue: [ 
			| a theta |
			a := HG2dPoint
				theta: v theta + Float pi
				r:
					(mu
						*
							(viscuss
								ifTrue: [ anHGParticle viscosity ]
								ifFalse: [ 1.0 ]) min: v norm2 / aNumber).
			anHGParticle addForce: a by: m ]
]

{ #category : 'initialize-release' }
HGFacialFriction >> initialize [
	super initialize.
	viscuss := true
]

{ #category : 'accessing' }
HGFacialFriction >> mu [
	^ mu
]

{ #category : 'accessing' }
HGFacialFriction >> mu: aNumber [
	mu := aNumber
]

{ #category : 'accessing' }
HGFacialFriction >> viscuss [
	^ viscuss
]

{ #category : 'accessing' }
HGFacialFriction >> viscuss: aBoolean [
	viscuss := aBoolean = true
]
