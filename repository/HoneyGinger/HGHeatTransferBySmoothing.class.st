Class {
	#name : 'HGHeatTransferBySmoothing',
	#superclass : 'HGAction',
	#instVars : [
		'kernel',
		'changes',
		'rate'
	],
	#category : 'HoneyGinger-Actions-Thermal',
	#package : 'HoneyGinger',
	#tag : 'Actions-Thermal'
}

{ #category : 'copyrights' }
HGHeatTransferBySmoothing class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGHeatTransferBySmoothing class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGHeatTransferBySmoothing class >> rate: aNumber kernel: anHGKernel [
	^ (self new)
		setKernel: anHGKernel;
		rate: aNumber;
		yourself
]

{ #category : 'copyrights' }
HGHeatTransferBySmoothing class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'simulating' }
HGHeatTransferBySmoothing >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| denominator temperature |
	denominator := 0.0.
	temperature := 0.0.
	anHGSimulator
		neighborsOf: anHGParticle position
		within: kernel support
		do: [ :neighbor :distance | 
			| gradient |
			gradient := kernel r: distance.
			temperature := neighbor temperature * gradient + temperature.
			denominator := denominator + gradient ].
	denominator > 0.0
		ifTrue: [ 
			temperature := anHGParticle temperature * (1.0 - rate) + (temperature * rate / denominator).
			changes add: anHGParticle -> temperature ]
]

{ #category : 'simulating' }
HGHeatTransferBySmoothing >> effectIn: anHGSimulator deltaT: aNumber [
	changes := OrderedCollection new: anHGSimulator numberOfParticles.
	super effectIn: anHGSimulator deltaT: aNumber.
	changes do: [ :atomic | atomic key temperature: atomic value ].
	changes := nil
]

{ #category : 'accessing' }
HGHeatTransferBySmoothing >> rate [
	^ rate
]

{ #category : 'accessing' }
HGHeatTransferBySmoothing >> rate: aNumber [
	rate := aNumber
]

{ #category : 'private' }
HGHeatTransferBySmoothing >> setKernel: anHGKernel [
	kernel := anHGKernel
]
