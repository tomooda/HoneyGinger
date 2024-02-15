Class {
	#name : 'HGMassDotsVisualizer',
	#superclass : 'HGDotsVisualizer',
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'drawing' }
HGMassDotsVisualizer >> draw: anHGSimulator on: aCanvas [
	anHGSimulator
		particlesDo: [ :particle | 
			| p form |
			p := particle position.
			p ifNotNil: [ | r |
				r := particle mass * radius.
				 aCanvas fillOval: ((p x - r) @ (p y - r) extent: 2 @ 2 * r) color: color ] ]
]
