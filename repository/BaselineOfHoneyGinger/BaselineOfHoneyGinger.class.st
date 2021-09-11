Class {
	#name : #BaselineOfHoneyGinger,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoneyGinger
}

{ #category : #baselines }
BaselineOfHoneyGinger >> baseline: spec [

	<baseline>
	spec
		baseline: 'GitBridge'
		with: [ spec repository: 'github://jecisc/GitBridge/src' ].
	spec for: #common do: [ 
		spec
			package: 'HoneyGinger'
			with: [ spec requires: #( 'GitBridge' ) ] ]
]
