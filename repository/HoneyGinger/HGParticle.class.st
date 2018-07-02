Class {
	#name : #HGParticle,
	#superclass : #Object,
	#instVars : [
		'position',
		'velocity',
		'pressure',
		'force',
		'temperature',
		'viscosity',
		'heat',
		'heatConductivity',
		'heatCapacity',
		'mass',
		'attributes'
	],
	#category : 'HoneyGinger-Particles'
}

{ #category : #copyrights }
HGParticle class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGParticle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGParticle class >> at: position velocity: velocity temperature: temperature mass: mass in: anHGSimulator [
	| particle |
	particle := self new.
	particle position: position.
	particle velocity: velocity.
	particle temperature: temperature.
	particle mass: mass.
	^ particle
]

{ #category : #copyrights }
HGParticle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #computing }
HGParticle >> addForce: anHGPoint by: aNumber [
	self force add: anHGPoint by: aNumber
]

{ #category : #computing }
HGParticle >> addForce: anHGPoint over: aNumber [
	self force add: anHGPoint over: aNumber
]

{ #category : #computing }
HGParticle >> addHeat: aNumber by: anotherNumber [
	heat := aNumber * anotherNumber + heat
]

{ #category : #computing }
HGParticle >> addPosition: anHGPoint by: aNumber [
	self position add: anHGPoint by: aNumber
]

{ #category : #computing }
HGParticle >> addPressure: anHGPoint by: aNumber [
	self pressure add: anHGPoint by: aNumber
]

{ #category : #computing }
HGParticle >> addTemperature: aNumber by: anotherNumber [
	self temperature: aNumber * anotherNumber + self temperature
]

{ #category : #computing }
HGParticle >> addVelocity: anHGPoint by: aNumber [
	self velocity add: anHGPoint by: aNumber
]

{ #category : #computing }
HGParticle >> addViscosity: aNumber by: anotherNumber [
	viscosity := aNumber * anotherNumber + viscosity
]

{ #category : #accessing }
HGParticle >> area [
	^ self position class areaFromVolume: self volume
]

{ #category : #'accessing - attributes' }
HGParticle >> at: aSymbol ifAbsent: errorBlock [
	^ attributes at: aSymbol asSymbol ifAbsent: errorBlock 
]

{ #category : #'accessing - attributes' }
HGParticle >> at: aSymbol put: anObject [
	attributes at: aSymbol asSymbol put: anObject
]

{ #category : #accessing }
HGParticle >> force [
	^ force
]

{ #category : #accessing }
HGParticle >> force: anHGPoint [
	force ifNil: [force := anHGPoint class zero].
	force set: anHGPoint.
	attributes at: #force put: force.

]

{ #category : #accessing }
HGParticle >> heat [
	^heat
]

{ #category : #accessing }
HGParticle >> heat: aNumber [
	heat := aNumber
]

{ #category : #accessing }
HGParticle >> heatCapacity [
	^ heatCapacity
]

{ #category : #accessing }
HGParticle >> heatCapacity: aNumber [
	heatCapacity := aNumber
]

{ #category : #accessing }
HGParticle >> heatConductivity [
	^ heatConductivity
]

{ #category : #accessing }
HGParticle >> heatConductivity: aNumber [
	heatConductivity := aNumber
]

{ #category : #'initialize-release' }
HGParticle >> initialize [
	attributes := IdentityDictionary new.
	self force: HG2dPoint zero.
	self velocity: HG2dPoint zero.
	self position: HG2dPoint zero.
	self heatConductivity: 10.0.
	self heatCapacity: 10.0.
	self temperature: 390
]

{ #category : #'accessing - attributes' }
HGParticle >> keysAndValuesDo: aBlock [
	attributes keysAndValuesDo: aBlock.
]

{ #category : #accessing }
HGParticle >> mass [
	^ mass
]

{ #category : #accessing }
HGParticle >> mass: aNumber [
	mass := aNumber
]

{ #category : #accessing }
HGParticle >> position [
	^ position
]

{ #category : #accessing }
HGParticle >> position: anHGPoint [
	position ifNil: [position := anHGPoint].
	position set: anHGPoint.
	attributes at: #p put: position
]

{ #category : #accessing }
HGParticle >> pressure [
	^ pressure
]

{ #category : #accessing }
HGParticle >> pressure: aNumber [
	pressure := aNumber.
	attributes at: #pressure put: aNumber
]

{ #category : #printing }
HGParticle >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	self position printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
HGParticle >> temperature [
	^  temperature
]

{ #category : #accessing }
HGParticle >> temperature: aNumber [
	temperature := aNumber.
	attributes at: #temperature put: aNumber
]

{ #category : #accessing }
HGParticle >> velocity [
	^ velocity
]

{ #category : #accessing }
HGParticle >> velocity: anHGPoint [
	velocity ifNil: [velocity := anHGPoint class zero].
	velocity set: anHGPoint.
	attributes at: #velocity put: velocity
]

{ #category : #accessing }
HGParticle >> viscosity [
	^ viscosity
]

{ #category : #accessing }
HGParticle >> viscosity: aNumber [
	viscosity := aNumber
]

{ #category : #accessing }
HGParticle >> volume [
	^ self mass
]
