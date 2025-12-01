Class {
	#name : 'HoneyGingerLauncher',
	#superclass : 'Morph',
	#instVars : [
		'simulator'
	],
	#category : 'HoneyGinger-Utilities',
	#package : 'HoneyGinger',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
HoneyGingerLauncher class >> open [
	<script: 'HoneyGingerLauncher open'>

	self new openInWindowLabeled: 'HoneyGinger Launcher'
]

{ #category : 'initialization' }
HoneyGingerLauncher >> initialize [
	super initialize.
	self color: Color white.
	self changeTableLayout.
	self listDirection: #bottomToTop.
	self wrapCentering: #center.
	self simulatorSelectors
		do: [ :selector | 
			| morph |
			morph := (SimpleButtonMorph newWithLabel: selector asString)
				on: #mouseDown send: #value to: [ self launch: selector ];
				yourself.
			self addMorph: morph.
			morph hResizing: #spaceFill ].
	^ self
]

{ #category : 'actions' }
HoneyGingerLauncher >> launch: aSymbol [
	| morph |
	simulator ifNotNil: [ :sim | sim delete ].
	morph := HGSimulator perform: aSymbol.
	[ morph isKindOf: SystemWindow ] whileFalse: [ morph := morph owner ].
	simulator := morph
]

{ #category : 'menu' }
HoneyGingerLauncher >> simulatorSelectors [
	^ #(
	greasyPit sandtrap3D
	silkyString5 gumString5 arrestingWire5 slackFence
	lagoonDots lagoonPolygons lagoonPressureMap lagoonPerspectiveDots
	splashDots splashPressureMap splashPressureBorderlineGraffitiFill
	lagoonPressureMapWorld
	watershowDots watershowPressureMap watershowSourceCode washoutDots
	jelloAtDie rockAtDie butterBallAtDie
	stickyBeans stickyBeansAtDie
	coldButterHotKnife hotButterColdKnife)
]
