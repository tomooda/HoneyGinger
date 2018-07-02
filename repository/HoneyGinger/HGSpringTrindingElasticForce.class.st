Class {
	#name : #HGSpringTrindingElasticForce,
	#superclass : #HGTrindingElasticForce,
	#instVars : [
		'k'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #copyrights }
HGSpringTrindingElasticForce class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGSpringTrindingElasticForce class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGSpringTrindingElasticForce class >> k: aNumber color: aColor [
	^ (self color: aColor)
		k: aNumber;
		yourself
]

{ #category : #copyrights }
HGSpringTrindingElasticForce class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #simulating }
HGSpringTrindingElasticForce >> effect: particle1 and: particle2 deltaPosition: delta deltaT: deltaT [
	| unit f |
	unit := particle1 position unitVector: particle2 position.
	f := (delta abs * k min: 100.0) * delta sign.
	f := delta * k.
	particle1 addForce: unit by: f.
	particle2 addForce: unit by: f * -1.0
]

{ #category : #simulating }
HGSpringTrindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber [
	| distanceBlock |
	distanceBlock := [ :particle1 :particle2 | particle1 velocity * aNumber + particle1 position distance: particle2 velocity * aNumber + particle2 position ].
	trindings
		do: [ :trinding | 
			self
				effect: trinding particle1
				and: trinding particle2
				deltaPosition: (distanceBlock value: trinding particle1 value: trinding particle2) - trinding standardDistance12
				deltaT: aNumber.
			self
				effect: trinding particle2
				and: trinding particle3
				deltaPosition: (distanceBlock value: trinding particle2 value: trinding particle3) - trinding standardDistance23
				deltaT: aNumber.
			self
				effect: trinding particle3
				and: trinding particle1
				deltaPosition: (distanceBlock value: trinding particle3 value: trinding particle1) - trinding standardDistance31
				deltaT: aNumber ].
]

{ #category : #accessing }
HGSpringTrindingElasticForce >> k [
	^ k
]

{ #category : #accessing }
HGSpringTrindingElasticForce >> k: aNumber [
	k := aNumber
]
