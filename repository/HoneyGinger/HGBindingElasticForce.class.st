Class {
	#name : #HGBindingElasticForce,
	#superclass : #HGElasticForce,
	#instVars : [
		'bindings',
		'color',
		'width',
		'breakrate'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #copyrights }
HGBindingElasticForce class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGBindingElasticForce class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGBindingElasticForce class >> color: aColor [
	^ (self new)
		color: aColor;
		yourself
]

{ #category : #copyrights }
HGBindingElasticForce class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #adding }
HGBindingElasticForce >> addBindingBetween: anHGParticle and: anotherHGParticle [
	| binding |
	binding := bindings
		detect: [ :bind | 
			(bind particle1 == anHGParticle and: [ bind particle2 == anotherHGParticle ])
				or: [ bind particle2 == anHGParticle and: [ bind particle1 == anotherHGParticle ] ] ]
		ifNone: [ bindings add: (HGBinding between: anHGParticle and: anotherHGParticle) ].
	binding standardDistance: binding distance.
	^ binding
]

{ #category : #accessing }
HGBindingElasticForce >> breakrate [
	^ breakrate 
]

{ #category : #accessing }
HGBindingElasticForce >> breakrate: aNumber [
	breakrate := aNumber
]

{ #category : #accessing }
HGBindingElasticForce >> color [
	^ color
]

{ #category : #accessing }
HGBindingElasticForce >> color: aColor [
	color := aColor
]

{ #category : #drawing }
HGBindingElasticForce >> draw: anHGSimulator on: aCanvas [
	bindings do: [ :binding |
		aCanvas line: binding particle1 position asPoint to: binding particle2 position asPoint width: width color: color ]

]

{ #category : #simulating }
HGBindingElasticForce >> effectIn: anHGSimulator deltaT: aNumber [
	| distanceBlock outlines |
	self effectShapesIn: anHGSimulator deltaT: aNumber.
	breakrate
		ifNotNil: [ self removeBindingSuchThat: [ :binding | binding distance > (binding standardDistance * breakrate) ] ].
	self color ifNotNil: [ self draw: anHGSimulator on: anHGSimulator form getCanvas ]
]

{ #category : #simulating }
HGBindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber. [
	^ self subclassResponsibility 
]

{ #category : #'initialize-release' }
HGBindingElasticForce >> initialize [
	super initialize.
	width := 1.
	bindings := OrderedCollection new: 160000.
]

{ #category : #removing }
HGBindingElasticForce >> removeBindingSuchThat: aBlock [
	bindings removeAllSuchThat: aBlock
]

{ #category : #accessing }
HGBindingElasticForce >> width [
	^ width
]

{ #category : #accessing }
HGBindingElasticForce >> width: aNumber [
	width := aNumber
]
