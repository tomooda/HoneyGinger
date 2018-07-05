Class {
	#name : #BaselineOfHoneyGinger,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoneyGinger
}

{ #category : #baselines }
BaselineOfHoneyGinger >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'HoneyGinger' ]
]
