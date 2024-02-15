Class {
	#name : 'HGCollisionPhonator',
	#superclass : 'HGPhonator',
	#instVars : [
		'particleIndex',
		'radius',
		'sound'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGCollisionPhonator class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGCollisionPhonator class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGCollisionPhonator class >> at: anInteger radius: aNumber sound: aSound [
	^ (self new)
		particleIndex: anInteger;
		radius: aNumber;
		sound: aSound;
		yourself
]

{ #category : 'simulating' }
HGCollisionPhonator >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [

]

{ #category : 'simulating' }
HGCollisionPhonator >> effectIn: anHGSimulator deltaT: aNumber [
	| particle volume |
	particle := anHGSimulator particleAt: particleIndex.
	particle ifNil: [ ^ self ].
	volume := 0.0.
	 anHGSimulator
		neighborsOf: particle position
		within: radius
		do: [ :neighbor :distance | 
			neighbor ~~ particle
				ifTrue: [ volume := volume max: (radius - distance) / radius ] ].
	volume > 0.0
		ifTrue: [ 
			(sound respondsTo: #loudness:) ifTrue: [sound loudness: volume].
			sound play ]
]

{ #category : 'accessing' }
HGCollisionPhonator >> particleIndex [
	^ particleIndex
]

{ #category : 'accessing' }
HGCollisionPhonator >> particleIndex: anInteger [
	particleIndex := anInteger
]

{ #category : 'accessing' }
HGCollisionPhonator >> radius [
	^ radius
]

{ #category : 'accessing' }
HGCollisionPhonator >> radius: aNumber [
	radius := aNumber
]

{ #category : 'accessing' }
HGCollisionPhonator >> sound [
	^ sound
]

{ #category : 'accessing' }
HGCollisionPhonator >> sound: aSound [
	sound := aSound
]
