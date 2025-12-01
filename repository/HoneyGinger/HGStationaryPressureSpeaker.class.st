Class {
	#name : 'HGStationaryPressureSpeaker',
	#superclass : 'HGSpeaker',
	#instVars : [
		'lastVelocity',
		'volumeScale',
		'minVolume',
		'maxVolume',
		'pitchScale',
		'minPitch',
		'maxPitch',
		'durationScale',
		'kernel'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGStationaryPressureSpeaker class >> kernel: anHGKernel [
	^ self new kernel: anHGKernel ; yourself
]

{ #category : 'simulating' }
HGStationaryPressureSpeaker >> effectIn: anHGSimulator deltaT: aNumber [ 
	| newPosition position sound pitch volume velocity denominator |
	newPosition := World activeHand position.
	(anHGSimulator bounds containsPoint: newPosition)
		ifFalse: [^ self].
	position := HG2dPoint fromPoint: newPosition - anHGSimulator bounds origin.
	velocity := anHGSimulator countAt: position kernel: kernel.
	volume := (lastVelocity - velocity) abs * volumeScale min: maxVolume max: minVolume.
	pitch :=  (lastVelocity - velocity) abs * pitchScale min: maxPitch max: minPitch.
	lastVelocity := velocity.
	sound := FMSound new.
	sound
		setPitch: pitch
		dur: aNumber * durationScale
		loudness: volume.
	sound play
]

{ #category : 'initialize-release' }
HGStationaryPressureSpeaker >> initialize [
	super initialize.
	lastVelocity := 0.0.
	volumeScale := 0.3.
	minVolume := 0.0.
	maxVolume := 0.2.
	pitchScale := 0.0.
	minPitch := 100.0.
	maxPitch := 1000.0.
	durationScale := 100.0 / 1000.0
]

{ #category : 'accessing' }
HGStationaryPressureSpeaker >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGStationaryPressureSpeaker >> kernel: anHGKernel [
	 kernel := anHGKernel
]

{ #category : 'simulating' }
HGStationaryPressureSpeaker >> oldeffectIn: anHGSimulator deltaT: aNumber [ 
	| newPosition position sound pitch volume velocity denominator |
	newPosition := World activeHand position.
	(anHGSimulator bounds containsPoint: newPosition)
		ifFalse: [^ self].
	position := HG2dPoint fromPoint: newPosition - anHGSimulator bounds origin.
	velocity := HG2dPoint zero.
	denominator := 0.0.
	anHGSimulator
		neighborsOf: position
		within: kernel support
		do: [:neighbor :distance | 
			| r |
			r := kernel r: distance.
			velocity add: neighbor velocity by: r.
			denominator := denominator + r].
	denominator > 0.0
		ifTrue: [velocity := velocity / denominator].
	volume := (lastVelocity - velocity) r * volumeScale min: maxVolume max: minVolume.
	pitch := (lastVelocity - velocity) r * pitchScale min: maxPitch max: minPitch.
	lastVelocity := HG2dPoint fromPoint: velocity.
	Transcript cr; show: 'p:', pitch printString, ' v:', volume printString.
	sound := FMSound new.
	sound
		setPitch: pitch
		dur: aNumber * durationScale
		loudness: volume.
	sound play
]

{ #category : 'initialize-release' }
HGStationaryPressureSpeaker >> oldinitialize [
	super initialize.
	lastVelocity := HG2dPoint zero.
	volumeScale := 0.01.
	minVolume := 0.0.
	maxVolume := 0.2.
	pitchScale := 0.0.
	minPitch := 100.0.
	maxPitch := 1000.0.
	durationScale := 200.0 / 1000.0
]
