Class {
	#name : #HGElasticBody,
	#superclass : #Object,
	#instVars : [
		'trindings',
		'particles',
		'pairs'
	],
	#category : 'HoneyGinger-Particles'
}

{ #category : #copyrights }
HGElasticBody class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGElasticBody class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #utilities }
HGElasticBody class >> isolatedBodiesWithAll: aCollectionOfHGTrinding [
	| bodies |
	bodies := OrderedCollection new.
	aCollectionOfHGTrinding
		do: [ :trinding | 
			| contacts |
			contacts := bodies select: [ :body | body hasContactWith: trinding ].
			contacts isEmpty
				ifTrue: [ bodies add: (self with: trinding) ]
				ifFalse: [ 
					| theOne theRest |
					theOne := contacts at: 1.
					theRest := contacts copyFrom: 2 to: contacts size.
					theRest
						do: [ :obsoleteTrinding | 
							theOne merge: obsoleteTrinding.
							bodies remove: obsoleteTrinding ].
					theOne add: trinding ] ].
	^ bodies
]

{ #category : #copyrights }
HGElasticBody class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGElasticBody class >> with: anHGTrinding [
	^ (self new)
		add: anHGTrinding;
		yourself
]

{ #category : #'instance creation' }
HGElasticBody class >> with: trinding1 with: trinding2 [
	^ (self new)
		add: trinding1;
		add: trinding2;
		yourself
]

{ #category : #'instance creation' }
HGElasticBody class >> with: trinding1 with: trinding2 with: trinding3 [
	^ (self new)
		add: trinding1;
		add: trinding2;
		add: trinding3;
		yourself
]

{ #category : #'instance creation' }
HGElasticBody class >> with: trinding1 with: trinding2 with: trinding3 with: trinding4 [
	^ (self new)
		add: trinding1;
		add: trinding2;
		add: trinding3;
		add: trinding4;
		yourself
]

{ #category : #'instance creation' }
HGElasticBody class >> withAll: aCollectionOfHGTrinding [
	| body |
	body := self new.
	aCollectionOfHGTrinding do: [ :trinding | body add: trinding ].
	^ body
]

{ #category : #adding }
HGElasticBody >> add: anHGTrinding [
	self merge: anHGTrinding.
	^ anHGTrinding
]

{ #category : #geometry }
HGElasticBody >> borderAt: anHG2dPoint [
	| minDistance nearestPoint |
	minDistance := Float infinity.
	nearestPoint := nil.
	self
		pairsDo: [ :particle1 :particle2 | 
			| point distance |
			point := particle1 position to: particle2 position nearestFrom: anHG2dPoint.
			distance := anHG2dPoint distance: point.
			distance < minDistance
				ifTrue: [ 
					minDistance := distance.
					nearestPoint := point ] ].
	^ nearestPoint
]

{ #category : #constraints }
HGElasticBody >> bump: anHGParticle [
	((self includesParticle: anHGParticle) not and: [ self contains: anHGParticle position ])
		ifTrue: [ 
			self
				nearestPointAndEdgeTo: anHGParticle position
				do: [ :p :vertex1 :vertex2 | 
					| newPosition kickBack v |
					newPosition := (p * (vertex1 mass + vertex2 mass) + (anHGParticle position * anHGParticle mass))
						/ (vertex1 mass + vertex2 mass + anHGParticle mass).
					kickBack := newPosition - p.
					v := (anHGParticle velocity * anHGParticle mass + (vertex1 velocity * vertex1 mass)
						+ (vertex2 velocity * vertex2 mass)) / (anHGParticle mass + vertex1 mass + vertex2 mass).
					anHGParticle position: newPosition.
					anHGParticle velocity: v.
					vertex1 addPosition: kickBack by: 1.0.
					vertex1 velocity: v.
					vertex2 addPosition: kickBack by: 1.0.
					vertex2 velocity: v ] ]
]

{ #category : #testing }
HGElasticBody >> contains: anHG2dPoint [
	^ trindings anySatisfy: [ :trinding | trinding contains: anHG2dPoint ]
]

{ #category : #testing }
HGElasticBody >> hasContactWith: anHGElasticBodyOrTrinding [
	^ particles anySatisfy: [ :particle | anHGElasticBodyOrTrinding includesParticle: particle ]
]

{ #category : #testing }
HGElasticBody >> includesParticle: anHGParticle [
	^ particles includes: anHGParticle  
]

{ #category : #'initialize-release' }
HGElasticBody >> initialize [
	super initialize.
	trindings := OrderedCollection new.
	particles := IdentitySet new.
	pairs := OrderedCollection new.

]

{ #category : #adding }
HGElasticBody >> merge: anHGElasticBody [
	anHGElasticBody trindingsDo: [ :trinding | trindings add: trinding ].
	anHGElasticBody particlesDo: [ :particle | particles add: particle ].
	anHGElasticBody
		pairsDo: [ :particle1 :particle2 | 
			(pairs
				detect:
					[ :edge | (edge at: 1) == particle2 and: [ (edge at: 2) == particle1 ] ]
				ifNone: [  ])
				ifNil: [ pairs add: (Array with: particle1 with: particle2) ]
				ifNotNil: [ :pairEdge | pairs remove: pairEdge ] ]
]

{ #category : #geometry }
HGElasticBody >> nearestPointAndEdgeTo: anHG2dPoint do: aBlock [
	| minDistance nearestPoint nearestVertex1 nearestVertex2 |
	minDistance := Float infinity.
	nearestPoint := nil.
	nearestVertex1 := nil.
	nearestVertex2 := nil.
	self
		pairsDo: [ :particle1 :particle2 | 
			| point distance |
			point := particle1 position to: particle2 position nearestFrom: anHG2dPoint.
			distance := anHG2dPoint distance: point.
			distance < minDistance
				ifTrue: [ 
					minDistance := distance.
					nearestPoint := point.
					nearestVertex1 := particle1.
					nearestVertex2 :=  particle2] ].
	nearestPoint ifNotNil: [aBlock value: nearestPoint value: nearestVertex1 value: nearestVertex2  ]
]

{ #category : #enumerating }
HGElasticBody >> pairsDo: aBlock [
	pairs do: [ :pair | aBlock valueWithArguments: pair]
]

{ #category : #enumerating }
HGElasticBody >> particlesDo: aBlock [
	particles do: aBlock
]

{ #category : #enumerating }
HGElasticBody >> trindingsDo: aBlock [
	trindings do: aBlock
]
