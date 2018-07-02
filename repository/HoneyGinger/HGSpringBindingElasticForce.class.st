Class {
	#name : #HGSpringBindingElasticForce,
	#superclass : #HGBindingElasticForce,
	#instVars : [
		'k'
	],
	#category : 'HoneyGinger-Actions-Elasticity'
}

{ #category : #'instance creation' }
HGSpringBindingElasticForce class >> k: aNumber color: aColor [
	^ (self color: aColor)
		k: aNumber;
		yourself
]

{ #category : #simulating }
HGSpringBindingElasticForce >> effect: particle1 and: particle2 deltaPosition: delta deltaT: deltaT [
	| unit f |
	unit := particle1 position unitVector: particle2 position.
	f := (delta abs * k min: 100.0) * delta sign.
	f := delta * k.
	particle1 addForce: unit by: f.
	particle2 addForce: unit by: f * -1.0
]

{ #category : #simulating }
HGSpringBindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber [
	| distanceBlock |
	distanceBlock := [ :particle1 :particle2 | particle1 velocity * aNumber + particle1 position distance: particle2 velocity * aNumber + particle2 position ].
	bindings
		do: [ :binding | 
			self
				effect: binding particle1
				and: binding particle2
				deltaPosition: (distanceBlock value: binding particle1 value: binding particle2) - binding standardDistance
				deltaT: aNumber ]
]

{ #category : #accessing }
HGSpringBindingElasticForce >> k [
	^ k
]

{ #category : #accessing }
HGSpringBindingElasticForce >> k: anObject [
	k := anObject
]
