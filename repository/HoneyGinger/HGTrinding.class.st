Class {
	#name : #HGTrinding,
	#superclass : #Object,
	#instVars : [
		'particle1',
		'particle2',
		'particle3',
		'standardDistance12',
		'standardDistance23',
		'standardDistance31'
	],
	#category : 'HoneyGinger-Particles'
}

{ #category : #copyrights }
HGTrinding class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGTrinding class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGTrinding class >> among: anHGPartcile1 and: anHGPartcile2 and: anHGPartcile3 [
	| trinding |
	trinding := (self new)
		particle1: anHGPartcile1;
		particle2: anHGPartcile2;
		particle3: anHGPartcile3;
		yourself.
	trinding standardDistance12: trinding distance12.
	trinding standardDistance23: trinding distance23.
	trinding standardDistance31: trinding distance31.
	^ trinding
]

{ #category : #copyrights }
HGTrinding class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #geometry }
HGTrinding >> area [
	^ (particle1 position to: particle2 position cross: particle3 position) / 2.0
]

{ #category : #geometry }
HGTrinding >> borderAt: anHG2dPoint [
	|  vertex1 vertex2 vertex3 point distance minDistance nearestPoint |
	vertex1 := particle1 position.
	vertex2 := particle2 position.
	vertex3 := particle3 position.
	point := vertex1 to: vertex2 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	minDistance := distance.
	nearestPoint := point.
	point := vertex2 to: vertex3 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestPoint := point ].
	point := vertex3 to: vertex1 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestPoint := point ].
	^ nearestPoint
]

{ #category : #geometry }
HGTrinding >> center [
	^ HG2dPoint x: (particle1 position x + particle2 position x + particle3 position x) / 3.0 y: (particle1 position y + particle2 position y + particle3 position y) / 3.0
]

{ #category : #testing }
HGTrinding >> contains: anHG2dPoint [
	^ (((particle1 position x min: particle2 position x) min: particle3 position x) <= anHG2dPoint x
		and: [ 
			((particle1 position y min: particle2 position y) min: particle3 position y) <= anHG2dPoint y
				and: [ 
					anHG2dPoint x <= ((particle1 position x max: particle2 position x) max: particle3 position x)
						and: [ anHG2dPoint y <= ((particle1 position y max: particle2 position y) max: particle3 position y) ] ] ])
		and: [ 
			| sign1 sign2 sign3 |
			sign1 := (particle1 position to: particle2 position cross: anHG2dPoint) sign.
			sign2 := (particle2 position to: particle3 position cross: anHG2dPoint) sign.
			sign3 := (particle3 position to: particle1 position cross: anHG2dPoint) sign.
			sign1 = 0 or: [ sign2 = 0 or: [ sign3 = 0 or: [ sign1 = sign2 and: [ sign2 = sign3 ] ] ] ] ]
]

{ #category : #geometry }
HGTrinding >> distance12 [
	^ particle1 position distance: particle2 position
]

{ #category : #geometry }
HGTrinding >> distance23 [
	^ particle2 position distance: particle3 position
]

{ #category : #geometry }
HGTrinding >> distance31 [
	^ particle3 position distance: particle1 position
]

{ #category : #testing }
HGTrinding >> includesParticle: anHGPartcile [
	^ anHGPartcile == particle1 or: [ anHGPartcile == particle2 or: [ anHGPartcile == particle3 ] ]
]

{ #category : #geometry }
HGTrinding >> nearestEdgeTo: anHG2dPoint do: aBlock [
	| vertex1 vertex2 vertex3 point distance minDistance nearestVertex1 nearestVertex2 |
	vertex1 := particle1 position.
	vertex2 := particle2 position.
	vertex3 := particle3 position.
	point := vertex1 to: vertex2 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	minDistance := distance.
	nearestVertex1 := vertex1.
	nearestVertex2 := vertex2.
	point := vertex2 to: vertex3 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestVertex1 := vertex2.
			nearestVertex2 := vertex3 ].
	point := vertex3 to: vertex1 nearestFrom: anHG2dPoint.
	distance := anHG2dPoint distance: point.
	distance < minDistance
		ifTrue: [ 
			minDistance := distance.
			nearestVertex1 := vertex3.
			nearestVertex2 := vertex1 ].
	aBlock value: nearestVertex1 value: nearestVertex2
]

{ #category : #enumerating }
HGTrinding >> pairsDo: aBlock [
	self area > 0.0
		ifTrue: [ 
			aBlock value: particle1 value: particle2.
			aBlock value: particle2 value: particle3.
			aBlock value: particle3 value: particle1 ]
]

{ #category : #accessing }
HGTrinding >> particle1 [
	^ particle1 
]

{ #category : #accessing }
HGTrinding >> particle1: anHGParticle [
	particle1 := anHGParticle 
]

{ #category : #accessing }
HGTrinding >> particle2 [
	^ particle2
]

{ #category : #accessing }
HGTrinding >> particle2: anHGParticle [
	particle2 := anHGParticle 
]

{ #category : #accessing }
HGTrinding >> particle3 [
	^ particle3
]

{ #category : #accessing }
HGTrinding >> particle3: anHGParticle [
	particle3 := anHGParticle 
]

{ #category : #enumerating }
HGTrinding >> particlesDo: aBlock [
	aBlock value: particle1.
	aBlock value: particle2.
	aBlock value: particle3
]

{ #category : #accessing }
HGTrinding >> standardDistance12 [ 
	^ standardDistance12 
]

{ #category : #accessing }
HGTrinding >> standardDistance12: aNumber [
	standardDistance12 := aNumber
]

{ #category : #accessing }
HGTrinding >> standardDistance23 [ 
	^ standardDistance23
]

{ #category : #accessing }
HGTrinding >> standardDistance23: aNumber [
	standardDistance23 := aNumber
]

{ #category : #accessing }
HGTrinding >> standardDistance31 [ 
	^ standardDistance31
]

{ #category : #accessing }
HGTrinding >> standardDistance31: aNumber [
	standardDistance31 := aNumber
]

{ #category : #enumerating }
HGTrinding >> trindingsDo: aBlock [
	aBlock value: self
]
