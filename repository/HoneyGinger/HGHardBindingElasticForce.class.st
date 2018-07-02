Class {
	#name : #HGHardBindingElasticForce,
	#superclass : #HGBindingElasticForce,
	#instVars : [
		'convergenceCoefficient',
		'steps'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #'instance creation' }
HGHardBindingElasticForce class >> steps: anInteger convergenceCoefficient: aNumber color: aColor [
	^ (super color: aColor)
		steps: anInteger;
		convergenceCoefficient: aNumber;
		yourself
]

{ #category : #'instance creation' }
HGHardBindingElasticForce class >> steps: anInteger convergenceCoefficient: aNumber color: aColor width: width [
	^ (super color: aColor)
		steps: anInteger;
		convergenceCoefficient: aNumber;
		width: width;
		yourself
]

{ #category : #accessing }
HGHardBindingElasticForce >> convergenceCoefficient [
	^ convergenceCoefficient
]

{ #category : #accessing }
HGHardBindingElasticForce >> convergenceCoefficient: anObject [
	convergenceCoefficient := anObject
]

{ #category : #simulating }
HGHardBindingElasticForce >> effect: particle1 and: particle2 deltaPosition: delta deltaT: deltaT [
	| v |
	particle1 addPosition: (particle1 position unitVector: particle2 position) by: delta / 2.0.
	particle2 addPosition: (particle2 position  unitVector: particle1 position) by: delta / 2.0.
	v := ((particle1 velocity * particle1 mass) + (particle2 velocity * particle2 mass)) / (particle1 mass + particle2 mass).
	particle1 velocity: v.
	particle2 velocity: v
]

{ #category : #simulating }
HGHardBindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber [
	| distanceBlock alpha |
	distanceBlock := [ :particle1 :particle2 | particle1 velocity * aNumber + particle1 position distance: particle2 velocity * aNumber + particle2 position ].
	alpha := convergenceCoefficient.
	steps
		timesRepeat: [ 
			| gamma |
			gamma := 1.0 - alpha.
			bindings
				do: [ :binding | 
					self
						effect: binding particle1
						and: binding particle2
						deltaPosition:
							((distanceBlock value: binding particle1 value: binding particle2) - binding standardDistance) * gamma
						deltaT: aNumber ].
			alpha := alpha * convergenceCoefficient ]
]

{ #category : #accessing }
HGHardBindingElasticForce >> steps [
	^ steps
]

{ #category : #accessing }
HGHardBindingElasticForce >> steps: anObject [
	steps := anObject
]
