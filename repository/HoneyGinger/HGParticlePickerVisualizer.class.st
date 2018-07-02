Class {
	#name : #HGParticlePickerVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'picker',
		'radius',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGParticlePickerVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGParticlePickerVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGParticlePickerVisualizer class >> on: anHGParticlePicker radius: aNumber color: aColor [
	^ (self new)
		picker: anHGParticlePicker;
		radius: aNumber;
		color: aColor;
		yourself
]

{ #category : #copyrights }
HGParticlePickerVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGParticlePickerVisualizer >> color [
	^ color
]

{ #category : #accessing }
HGParticlePickerVisualizer >> color: aColor [
	color := aColor
]

{ #category : #drawing }
HGParticlePickerVisualizer >> draw: anHGSimulator on: aCanvas [
	self
		in: anHGSimulator
		particlesDo: [ :particle | 
			| p |
			p := particle position.
			aCanvas fillOval: ((p x - radius) @ (p y - radius) extent: 2 @ 2 * radius) color: color ]
]

{ #category : #enumerating }
HGParticlePickerVisualizer >> in: anHGSimulator particlesDo: aBlock [
	picker ifNotNil: [ picker in: anHGSimulator particlesDo: aBlock ]
]

{ #category : #accessing }
HGParticlePickerVisualizer >> particle [
	^ picker pickedParticle
]

{ #category : #accessing }
HGParticlePickerVisualizer >> picker [
	^ picker
]

{ #category : #accessing }
HGParticlePickerVisualizer >> picker: anHGParticlePicker [
	picker := anHGParticlePicker 
]

{ #category : #accessing }
HGParticlePickerVisualizer >> radius [
	^ radius
]

{ #category : #accessing }
HGParticlePickerVisualizer >> radius: aNumber [
	radius := aNumber
]
