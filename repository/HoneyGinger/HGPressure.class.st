Class {
	#name : 'HGPressure',
	#superclass : 'HGAction',
	#instVars : [
		'gasConstant',
		'kernel'
	],
	#category : 'HoneyGinger-Actions-FluidDynamics',
	#package : 'HoneyGinger',
	#tag : 'Actions-FluidDynamics'
}

{ #category : 'copyrights' }
HGPressure class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGPressure class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGPressure class >> gasConstant: aNumber kernel: anHGKernel [
	^ self new setGasConstant: aNumber kernel: anHGKernel
]

{ #category : 'copyrights' }
HGPressure class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGPressure >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| count |
	count := 0.0.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | count := (kernel r: distance) + count ].
	anHGParticle pressure: count * gasConstant
]

{ #category : 'accessing' }
HGPressure >> gasConstant [
	^gasConstant
]

{ #category : 'accessing' }
HGPressure >> kernel [
	^ kernel
]

{ #category : 'private' }
HGPressure >> setGasConstant: aNumber kernel: anHGKernel [
	gasConstant := aNumber.
	kernel := anHGKernel
]
