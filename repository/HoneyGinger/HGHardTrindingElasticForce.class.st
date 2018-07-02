Class {
	#name : #HGHardTrindingElasticForce,
	#superclass : #HGTrindingElasticForce,
	#instVars : [
		'convergenceCoefficient',
		'steps'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #copyrights }
HGHardTrindingElasticForce class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGHardTrindingElasticForce class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGHardTrindingElasticForce class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGHardTrindingElasticForce class >> steps: anInteger convergenceCoefficient: aNumber color: aColor [
	^ (super color: aColor)
		steps: anInteger;
		convergenceCoefficient: aNumber;
		yourself
]

{ #category : #accessing }
HGHardTrindingElasticForce >> convergenceCoefficient [
	^ convergenceCoefficient 
]

{ #category : #accessing }
HGHardTrindingElasticForce >> convergenceCoefficient: aNumber [
	convergenceCoefficient := aNumber min: 1.0 max: 0.0
]

{ #category : #simulating }
HGHardTrindingElasticForce >> effect: particle1 and: particle2 deltaPosition: delta deltaT: deltaT [
	| v |
	particle1 addPosition: (particle1 position unitVector: particle2 position) by: delta / 2.0.
	particle2 addPosition: (particle2 position  unitVector: particle1 position) by: delta / 2.0.
	v := ((particle1 velocity * particle1 mass) + (particle2 velocity * particle2 mass)) / (particle1 mass + particle2 mass).
	particle1 velocity: v.
	particle2 velocity: v
]

{ #category : #simulating }
HGHardTrindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber [
	| distanceBlock alpha |
	distanceBlock := [ :particle1 :particle2 | particle1 velocity * aNumber + particle1 position distance: particle2 velocity * aNumber + particle2 position ].
	alpha := convergenceCoefficient.
	steps
		timesRepeat: [ 
			| gamma |
			gamma := 1.0 - alpha.
			trindings
				do: [ :trinding | 
					self
						effect: trinding particle1
						and: trinding particle2
						deltaPosition: (distanceBlock value: trinding particle1 value: trinding particle2) - trinding standardDistance12 * gamma 
						deltaT: aNumber.
					self
						effect: trinding particle2
						and: trinding particle3
						deltaPosition: (distanceBlock value: trinding particle2 value: trinding particle3) - trinding standardDistance23 * gamma
						deltaT: aNumber.
					self
						effect: trinding particle3
						and: trinding particle1
						deltaPosition: (distanceBlock value: trinding particle3 value: trinding particle1) - trinding standardDistance31 * gamma
						deltaT: aNumber ].
					alpha := alpha * convergenceCoefficient  ]
]

{ #category : #accessing }
HGHardTrindingElasticForce >> steps [
	^steps
]

{ #category : #accessing }
HGHardTrindingElasticForce >> steps: anInteger [
	steps := anInteger
]
