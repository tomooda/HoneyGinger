Class {
	#name : 'HGObstacle',
	#superclass : 'HGAction',
	#instVars : [
		'region',
		'color',
		'afterEffect'
	],
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'copyrights' }
HGObstacle class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGObstacle class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGObstacle class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGObstacle class >> with: anHG2dRegion [
	^ self with: anHG2dRegion color: nil
]

{ #category : 'instance creation' }
HGObstacle class >> with: anHG2dRegion color: aColor [
	^ self new setRegion: anHG2dRegion  color: aColor
]

{ #category : 'accessing' }
HGObstacle >> afterEffect [
	^ afterEffect
]

{ #category : 'accessing' }
HGObstacle >> afterEffect: aBlock [
	afterEffect := aBlock
]

{ #category : 'simulating' }
HGObstacle >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	| position |
	position := anHGParticle position.
	(region contains: position)
		ifTrue: [ 
			anHGParticle velocity set: HG2dPoint zero.
			anHGParticle position set: (region borderAt: position).
			afterEffect ifNotNil: [ afterEffect value: anHGParticle value: aNumber ] ]
]

{ #category : 'simulating' }
HGObstacle >> effectIn: anHGSimulator deltaT: aNumber [
	super effectIn: anHGSimulator deltaT: aNumber.
	color ifNotNil: [region drawOn: anHGSimulator form getCanvas color: color]
]

{ #category : 'private' }
HGObstacle >> setRegion: anHG2dRegion color: aColor [
	region := anHG2dRegion.
	color := aColor
]
