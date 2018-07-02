Class {
	#name : #HGSimulator,
	#superclass : #BorderedMorph,
	#instVars : [
		'random',
		'simulationOrigin',
		'simulationCorner',
		'simulationTime',
		'viewExtent',
		'offset',
		'actions',
		'initializers',
		'particleMap',
		'particleMapResolution',
		'particles',
		'visibleForm',
		'form'
	],
	#category : 'HoneyGinger-Simulator'
}

{ #category : #copyrights }
HGSimulator class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGSimulator class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'applications-flows' }
HGSimulator class >> aerowing [
	"HGSimulator aerowing"

	| form1 form2 form simulator vy background |
	vy := -10.0.
	form1 := Form extent: 500@500 depth: 32.
	form1 getCanvas fillColor: Color white; drawImage: (Form fromFileNamed: 'wing.png') at: 0@100; flush.	
	form2 := Form extent: 500@500 depth: 32.
	form2 getCanvas fillColor: Color white; drawImage: (Form fromFileNamed: 'wing2.png') at: 0@100; flush.
	form := form1.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: 0.0 y: vy)).
	simulator addInitializer: (HGTemperatureInitialization with: 390).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.3 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGSlipperyObstacle with: (HG2dBlockRegion on: [ :position | (form colorAt: position asPoint) luminance < 0.5 ])).	
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [
		simulator particlesDo: [ :particle |
			(particle position x < 10.0 or: [particle position x > 490.0]) ifTrue: [particle velocity x: 0.0; y: vy]]]).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [
		simulator particlesDo: [ :particle |
			(particle position y < 10.0) ifTrue: [particle position x: simulator random next * 500; y: particle position y + 490.0.
				particle velocity: (HG2dPoint x: 0.0 y: vy)]]]).
	simulator addAction: (HGTriggerBlockAction whenever: [false] do: [vy := vy - 0.01]).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ ActiveHand anyButtonPressed ifTrue: [form := form2] ifFalse: [form := form1]. background form: form]).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: form).
	"simulator addAction: (HGDotsVisualizer radius: 3 color: Color blue)."
	simulator
		addAction:
			((HGMeshVelocityVisualizer xgrids: 30
		ygrids: 30
		kernel: (HGSimpleKernel support: 40)
		radius: 1
		width: 1
		scale: 2.0
		color: Color black)).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Flood'.
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> arrestingWire1 [
	"HGSimulator arrestingWire1"

	| random simulator bindingAction stick firsts lasts |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 20
				convergenceCoefficient: 0.1
				color: Color gray
				width: 4).
	simulator addAction: (HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	250 to: 250 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 200.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		200 to: 300 by: 10 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 5) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ].
	(self
		verticalPanel:
			(Array with: (self selectorPanel: 'Tension' do: [ :steps | bindingAction steps: steps ] withAll: #(1 5 10 20))))
		 addMorph: simulator; openInWindowLabeled: 'Arresting Wire 1'.
	simulator startStepping..
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> arrestingWire5 [
	"HGSimulator arrestingWire5"

	| random simulator bindingAction stick firsts lasts |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 20
				convergenceCoefficient: 0.1
				color: Color gray
				width: 2).
	simulator addAction: (HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	240 to: 260 by: 4 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 200.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		200 to: 300 by: 10 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 5.0) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ].
	(self
		verticalPanel:
			(Array with: (self selectorPanel: 'Tension' do: [ :steps | bindingAction steps: steps ] withAll: #(1 5 10 20))))
		 addMorph: simulator; openInWindowLabeled: 'Arresting Wire 5'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> bouncingBalls [
	"HGSimulator bouncingBalls"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: (HG2dPoint fromPoint: simulator bounds origin)
				corner: (HG2dPoint fromPoint: simulator bounds corner)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: 0.01 y: 0.0)).
	simulator addInitializer: (HGPressureInitialization with: 2.0).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 24.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.098)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.9).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGFormVisualizer footballs.
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 400 ].
	simulator openInWindowLabeled: 'Football'.
	^ simulator
]

{ #category : #'applications-distributed-servers' }
HGSimulator class >> bouncingBallsServer [
	"HGSimulator bouncingBallsServer"

	"HGSimulator allInstancesDo: [ :m | m delete]"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: (HG2dPoint fromPoint: simulator bounds origin)
				corner: (HG2dPoint fromPoint: simulator bounds corner)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: 0.01 y: 0.0)).
	simulator addInitializer: (HGPressureInitialization with: 2.0).
	simulator addInitializer: (HGPVTUploader address: #[127 0 0 1] port: 9800).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 24.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.098)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.9).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPVTUploader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGFormVisualizer footballs.
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 400 ].
	simulator openInWindowLabeled: 'Football Server'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> burningHand [
	"HGSimulator burningHand"
	| random simulator refraction heat gravity |
	random := Random new.
	simulator := HGSimulator new.
	simulator
		color: ((Color brown mixed: 0.4 with: Color gray)
				alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator
		simulationOrigin: (HG2dPoint x: 0.0 y: 0.0)
		corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator
		addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator
		addAction: (HGPositionNoise
				withBlock: [random next @ random next * 0.01]).
	simulator
		addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction: (HGPressure
				gasConstant: 0.01
				kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: (gravity := HGGravity
					g: (HG2dPoint x: 0 y: -2.0)).
	simulator
		addAction: (HGPressureRepulsion
				kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator
		addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction: (HGViscosityTraction
				kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: HGLocalityMap withOutOfBoundsRemoval.
	simulator
		addAction: (HGTriggerBlockAction
				whenever: [simulator bounds containsPoint: ActiveHand position]
				do: [20
						timesRepeat: [(simulator
								addParticleAt: simulator random next - 0.5 @ (simulator random next * 2.0 - 1.8) * 40 + ActiveHand position - simulator position
								temperature: 370.0
								mass: 300.0)
								viscosity: 79.0]]).
	simulator
		addAction: (HGBackgroundImageVisualizer
				form: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (heat := HGMeshPressureVisualizer
					scale: 0.0
					bias: 0.0
					color: (Color lightOrange mixed: 0.2 with: Color lightRed)).
	simulator addAction: (refraction := HGRefractionVisualizer
					xgrids: 60
					ygrids: 60
					kernel: (HGSimpleKernel support: 5.0)
					scale: 0.0
					image: nil).
	(self
		verticalPanel: (Array
				with: (self
						selectorPanel: 'Temperature'
						do: [:scale | 
							heat scale: scale / 500.0.
							refraction scale: scale / 10.0]
						withAll: #(0 100 300 ))
				with: (self
						selectorPanel: 'Upstream'
						do: [:gy | gravity g y: gy negated]
						withAll: #(0.5 1.0 2.0 4.0 8.0 )))) addMorphBack: simulator;
		 openInWindowLabeled: 'Burning Hand'.
	simulator setupSimulation; startStepping.
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBall [
	"HGSimulator butterBall"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dCircle center: (HG2dPoint x: 100.0 y: 350.0) radius: 110.0) color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 2.5 color: Color yellow).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 100.0 ].
	simulator openInWindowLabeled: 'Butter Ball'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBallAtDie [
	"HGSimulator butterBallAtDie"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 2.5 color: Color yellow).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Butter Ball at a Die'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBallAtDie3D [
	"HGSimulator butterBallAtDie3D"

	| simulator perspective |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	"simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1))."
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveDotsVisualizer
				radius: 5.0
				color: Color yellow
				eyeHeight: 10
				vanishingPoint: 250 @ 500
				depthBlock: [ :sim :particle | particle pressure * -5.0 max: -9 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective sightPoint: p - simulator position ] ]).

	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Butter Ball at a Die'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBallAtTriangle [
	"HGSimulator butterBallAtTriangle"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 230.0) on: (HG2dPoint x: 300.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 2.5 color: Color yellow).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Butter Ball at a Triangle'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBallGraffitiAtDie [
	"HGSimulator butterBallGraffitiAtDie"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			((HGBorderlineFillPressureVisualizer pressure: 0.01 color: Color yellow)
				kernel: (HGSimpleKernel support: 10.0);
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.01 width: 3 color: Color black)
				xgrids: 50;
				ygrids: 50;
				kernel: (HGSimpleKernel support: 10.0);
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.01 width: 3 color: Color black)
				kernel: (HGSimpleKernel support: 10.0);
				xgrids: 60;
				ygrids: 60;
				yourself).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Butter Ball at a Die (Graffiti)'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> butterBallToonAtDie [
	"HGSimulator butterBallToonAtDie"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			((HGBorderlineFillPressureVisualizer pressure: 0.01 color: Color yellow)
				kernel: (HGSimpleKernel support: 10.0);
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.01 width: 4 color: Color black)
				kernel: (HGSimpleKernel support: 10.0);
				yourself).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Butter Ball at a Die (Toon)'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-thermal' }
HGSimulator class >> butterKnifeCold [
	"HGSimulator butterKnifeCold"

	| simulator view |
	simulator := HGSimulator new.
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(HGDynamicDotsVisualizer
				radius: [ :s :p | 4 ]
				color: [ :s :p | Color yellow alpha: ((373.15 - p temperature) / 100.0 * 0.9 + 0.1 min: 1.0 max: 0.1) ]).
	simulator addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3 color: (Color gray: 0.7))).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Cold Butter Knife'.
	simulator color: (Color gray: 0.98).
	^ simulator
]

{ #category : #'applications-thermal' }
HGSimulator class >> butterKnifeHot [
	"HGSimulator butterKnifeHot"

	| simulator view |
	simulator := HGSimulator new.
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 300).
	simulator addAction: (HGTriggerBlockAction whenever: [ true ] do: [ (simulator particleAt: 1) temperature: 370 ]).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 7.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 17.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(HGDynamicDotsVisualizer
				radius: [ :s :p | 4 ]
				color: [ :s :p | Color yellow alpha: ((373.15 - p temperature) / 100.0 * 0.9 + 0.1 min: 1.0 max: 0.1) ]).
	simulator
		addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3 color: (Color gray: 0.7))).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Hot Butter Knife'.
	simulator color: (Color gray: 0.98).
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> capuccino [
	"HGSimulator capuccino"
	
	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 400).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGFormVisualizer capuccino.
	simulator
		addAction:
			(HGFakeHand
				at: 1
				mickey: 0.25
				image:
					(HGInertialFakeHand circle: 8 color: Color red)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 24 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Capuccino Art'.
	simulator color: Color brown.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> capuccino3D [
	"HGSimulator capuccino3D"
	
	| simulator perspective |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 400).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveDotsVisualizer
				radius: 10
				color: Color white
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 - (particle pressure * 3) max: -29 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed  ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	simulator
		addAction:
			(HGFakeHand
				at: 1
				mickey: 0.25
				image:
					(HGInertialFakeHand circle: 8 color: Color red)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 24 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Capuccino Art'.
	simulator color: Color brown.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> capuccinoPower [
	"HGSimulator capuccinoPower"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 400).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGFormVisualizer capuccino.
	simulator
		addAction:
			(HGInertialFakeHand
				at: 1
				mickey: 2.0
				image:
					(HGInertialFakeHand circle: 8 color: Color red)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 24 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Capuccino Art'.
	simulator color: Color brown.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> clearGreasyPit [
	"HGSimulator clearGreasyPit"

	| simulator friction sweeping stick |
	simulator := HGSimulator new.
	simulator extent: 300 @ 300.
	simulator color: Color white.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 100 @ 100 corner: 300 @ 300).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: (friction := HGFacialFriction mu: 0.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGTriggerAction
				whenever: [ sweeping ]
				action:
					(HGBumpyObstacle
						with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 50.0)
						color: nil)).
	sweeping := false.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGRefractionVisualizer scale: 40.0 image: (Form fromDisplay: (0@0 corner: 300@300))).
	simulator addAction: ((HGMeshPressureVisualizer color: Color blue) kernel: (HGSimpleKernel support: 30)).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	(self
		verticalPanel:
			(Array
				with: (self selectorPanel: 'Radius' do: [:radius | stick radius: radius asFloat] withAll: #(30 50 60 70 80 100))
				with: (self selectorPanel: 'Friction' do: [ :mu | friction mu: mu asFloat ] withAll: #(0.0 0.01 0.02))))
		addMorph: simulator;
		openInWindowLabeled: 'Clear Greasy Pit'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #'applications-thermal' }
HGSimulator class >> coldButterColdKnife [
	"HGSimulator coldButterColdKnife"

	| simulator view |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGThermalDotsVisualizer radius: 3.0 blueTemperature: 273.15 redTemperature: 373.15).
	simulator
		addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 4 color: (Color gray: 0.9))).
	simulator addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Butter Knife'.
	^ simulator
]

{ #category : #'applications-thermal' }
HGSimulator class >> coldButterHotKnife [
	"HGSimulator coldButterHotKnife"

	| simulator view |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [(simulator particleAt: 1) temperature: 400]).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 15.0)).	
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction:  (HGThermalDotsVisualizer radius: 3.0 blueTemperature: 273.15 redTemperature: 373.15).
	simulator addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Butter Knife'.
	^ simulator
]

{ #category : #images }
HGSimulator class >> dot [
	| form |
	form := Form extent: 1 @ 1 depth: 32.
	(form getCanvas)
		fillColor: Color black;
		flush.
	^ form
]

{ #category : #'applications-constraints' }
HGSimulator class >> dotsInUserImage: rate [
	"HGSimulator dotsInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [true]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator addAction: (HGDotsVisualizer radius: 4 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Dots)'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> dotsViewer [
	"HGSimulator dotsViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: (HGHandParticle at: 2).
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color black).
	simulator addAction: (HGDotVisualizer at: 2 radius: 3.0 color: Color red).
	simulator
		addAction:
			((HGPVTUploader address: #[127 0 0 1] port: 9800)
				suchThat: [ :particleIndex | particleIndex = 1 and: [ActiveHand anyButtonPressed ] ];
				yourself).
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Dots Viewer'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> floodPolygons [
	"HGSimulator floodPolygons"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: (Color lightBlue mixed: 0.8 with: Color blue)).
	400
		timesRepeat: [ 
			simulator
				addParticleAt: 0 @ 0
				temperature: 390
				mass: 300 ].
	simulator openInWindowLabeled: 'Flood'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> floodPressureMap [
	"HGSimulator floodPressureMap"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Flood'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> footballViewer [
	"HGSimulator footballViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: (HGHandParticle at: 3).
	simulator addAction: (HGPVTUploader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGFormVisualizer footballs.
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Football Viewer'.
	^ simulator
]

{ #category : #'applications-constraints' }
HGSimulator class >> graffitiInUserImage: rate [
	"HGSimulator graffitiInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator
		addAction:
			((HGBorderlineFillPressureVisualizer pressure: 0.05 color: (Color blue alpha: 0.5)) kernel: (HGSimpleKernel support: 20)).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.05 width: 2 color: Color black)
				xgrids: 50;
				ygrids: 50;
				kernel: (HGSimpleKernel support: 20)).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.05 width: 2 color: Color black)
				xgrids: 60;
				ygrids: 60;
				kernel: (HGSimpleKernel support: 20)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> grease [
	"HGSimulator grease"

	| sweeping random simulator width randomPosition viscosity pressure friction smoothing stick stud resetButton viscosityPanel solidityPanel radiusPanel studPanel |
	sweeping := false.
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color lightGray muchLighter.
	simulator extent: 500 @ 500.
	simulator particleMapResolution: 10.
	width := 10.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (randomPosition := HGRandomPosition origin: 200 @ 200 corner: 300 @ 300).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (viscosity := HGViscosityInitialization with: 1.0).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (pressure := HGPressureRepulsion kernel: (HGSimpleKernel support: 1.0) maxPressure: 100.0).
	simulator addAction: (friction := HGFacialFriction mu: 5.0 viscuss: false).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (smoothing := HGViscosityBySmoothing kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			((HGBumpyObstacle
				with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0)
				color: nil)
				afterEffect: [ :particle :deltaT | particle addVelocity: stick to - stick from by: 0.5 * particle viscosity / deltaT ];
				yourself).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(stud := HGStudsVisualizer
				offset: 0 @ 0
				radius: 8.0
				color: Color yellow darker
				offset: 0 @ -1
				radius: 8.0
				color: Color yellow).
	500 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	resetButton := (SimpleButtonMorph newWithLabel: 'RESET')
		on: #mouseDown
			send: #value
			to: [ 
					sweeping := false.
					simulator setupSimulation ];
		yourself.
	viscosityPanel := self
		selectorPanel: 'Viscosity'
		do: [ :v | 
			viscosity viscosity: v.
			sweeping := false.
			simulator setupSimulation ]
		withAll: #(1.0 0.5 0.1 0.0).
	solidityPanel := self
		selectorPanel: 'Solidity'
		do: [ :h | 
			smoothing kernel setSupport: h asFloat.
			sweeping := false.
			simulator setupSimulation ]
		withAll: #(1 5 10 20).
	radiusPanel := self
		selectorPanel: 'Radius'
		do: [ :r | 
			stick radius: r.
			sweeping := false.
			simulator setupSimulation ]
		withAll: #(10 20 30).
	studPanel := self
		selectorPanel: 'Stud'
		do: [ :h |
			stud offset: 0 @ 0
				radius: 8.0
				color: Color yellow darker
				offset: 0 @ (0 - h)
				radius: 8.0
				color: Color yellow.
				simulator setupSimulation]
			withAll: #(1 4 8 12).
	(self
		verticalPanel:
			(Array
				with: resetButton
				with: viscosityPanel
				with: solidityPanel
				with: radiusPanel
				with: studPanel))
		addMorph: simulator;
		openInWindowLabeled: 'Porsche'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> greasyPit [
	"HGSimulator greasyPit"

	| simulator friction sweeping stick color1 color2 perspective1 perspective2 |
	simulator := HGSimulator new.
	simulator extent: 300 @ 300.
	simulator color: Color white.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 100 @ 100 corner: 300 @ 300).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: (friction := HGFacialFriction mu: 0.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGTriggerAction
				whenever: [ sweeping ]
				action:
					(HGBumpyObstacle
						with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 50.0)
						color: nil)).
	sweeping := false.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	color1 := ValueHolder new.
	color1 contents: (Color gray: 0.9).
	color2 := ValueHolder new.
	color2 contents: (Color gray: 0.5).
	simulator
		addAction:
			(perspective1 := HGPerspectiveDotsVisualizer
				radius: 18
				color: nil
				eyeHeight: 30
				vanishingPoint: 150 @ 150
				depthBlock: [ :sim :particle | 20 ]
				colorBlock: [ :c :z | color2 contents]).
	simulator
		addAction:
			(perspective2 := HGPerspectiveDotsVisualizer
				radius: 18
				color: nil
				eyeHeight: 30
				vanishingPoint: 150 @ 150
				depthBlock: [ :sim :particle | 20 - (particle pressure * 10) max: -29 ]
				colorBlock: [ :c :z | | w | w := (1.0 - (z / 30.0) min: 1.0 max: 0.0).  (color1 contents mixed: w with: color2 contents) alpha: color1 contents alpha * w + (color2 contents alpha * (1.0 - w)) ]).
	"simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective1 vanishingPoint: p - simulator position.
							perspective2 vanishingPoint: p - simulator position ] ])."
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective1
								projectPoint: p - simulator position
								z: 20.0
								in: simulator
								do: [ :x :y :z :a | 
									simulator form getCanvas
										in: [ :canvas | 
											canvas
												line: p - simulator position
												to: x @ y
												width: 5
												color: Color black ] ] ] ]).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	(self
		verticalPanel:
			(Array
				with: ((ColorChooserMorph on: color1 color: #contents changeColor: #contents:) extent: 200@20)
				with: ((ColorChooserMorph on: color2 color: #contents changeColor: #contents:) extent: 200@20)
				with: (self selectorPanel: 'Radius' do: [:radius | stick radius: radius asFloat] withAll: #(30 50 60 70 80 100))
				with: (self selectorPanel: 'Friction' do: [ :mu | friction mu: mu asFloat ] withAll: #(0.0 0.01 0.02))))
		addMorph: simulator;
		openInWindowLabeled: 'Greasy Pit'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> gumString1 [
	"HGSimulator gumString1"

	| random simulator bindingAction stick resetBlock firsts lasts |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 10
				convergenceCoefficient: 0.1
				color: Color gray
				width: 4).
	bindingAction breakrate: 4.0.
	simulator addAction: (HGStickyObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	resetBlock := [ 
	bindingAction removeBindingSuchThat: [ :binding | true ].
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	simulator clearParticles.
	250 to: 250 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 0.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		2 to: 500 by: 4 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 1) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ] ].
	resetBlock value.
	(self
		verticalPanel:
			(Array
				with:
					((SimpleButtonMorph newWithLabel: 'RESET')
						on: #mouseDown send: #value to: resetBlock;
						yourself)
				with:
					(self selectorPanel: 'Tension' do: [:steps | bindingAction steps: steps] withAll: #(1 2 5 10))
				with: (self selectorPanel: 'Strength' do: [ :rate | bindingAction breakrate: rate asFloat] withAll: #(3 4 5)))) 		 addMorph: simulator; openInWindowLabeled: 'Gum String 1'.
	simulator startStepping..

	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> gumString5 [
	"HGSimulator gumString5"

	| random simulator bindingAction stick firsts lasts resetBlock |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 10
				convergenceCoefficient: 0.1
				color: Color gray
				width: 1).
	bindingAction breakrate: 4.0.
	simulator addAction: (HGStickyObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	resetBlock := [ 
	simulator clearParticles.
	bindingAction removeBindingSuchThat: [ :binding | true ].
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	240 to: 260 by: 4 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 0.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		5 to: 500 by: 4 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 2) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ] ].
	resetBlock value.
	(self
		verticalPanel:
			(Array
				with:
					((SimpleButtonMorph newWithLabel: 'RESET')
						on: #mouseDown send: #value to: resetBlock;
						yourself)
				with: (self selectorPanel: 'Tension' do: [ :steps | bindingAction steps: steps ] withAll: #(1 2 5 10))
				with: (self selectorPanel: 'Strength' do: [ :rate | bindingAction breakrate: rate asFloat ] withAll: #(3 4 5))))
		 addMorph: simulator; openInWindowLabeled: 'Gum String5'.
	simulator startStepping..
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> handVelocityViewer [
	"HGSimulator handVelocityViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.0 color: Color black).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 40.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: true;
				yourself).
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Hand-Velocity Viewer'.
	^ simulator
]

{ #category : #utilities }
HGSimulator class >> horizontalPanel: anArrayOfMorphs [
	| panel |
	panel := Morph new.
	panel color: Color white.
	panel changeTableLayout.
	panel listDirection: #rightToLeft.
	panel wrapCentering: #bottomRight.
	anArrayOfMorphs
		do: [ :morph | 
			panel addMorph: morph ].
	^ panel
]

{ #category : #'applications-thermal' }
HGSimulator class >> hotButterColdKnife [
	"HGSimulator hotButterColdKnife"

	| simulator view |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 400).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [(simulator particleAt: 1) temperature: 270]).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 15.0)).	
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction:  (HGThermalDotsVisualizer radius: 3.0 blueTemperature: 273.15 redTemperature: 373.15).
	simulator addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Butter Knife'.
	^ simulator
]

{ #category : #'applications-thermal' }
HGSimulator class >> hotButterHotKnife [
	"HGSimulator hotButterHotKnife"

	| simulator view |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 300 @ 300.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 200 @ 200).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 400).
	simulator addAction: (HGHeatTransferBySmoothing rate: 0.9 kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 0.02).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGThermalDotsVisualizer radius: 3.0 blueTemperature: 273.15 redTemperature: 373.15).
	simulator addAction: (HGInertialFakeHand at: 1 mickey: 1.0 image: (HGInertialFakeHand circle: 3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Butter Knife'.
	^ simulator
]

{ #category : #'applications-constraints' }
HGSimulator class >> illustratedInUserImage: rate [
	"HGSimulator illustratedInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator
		addAction:
			((HGBorderlineFillPressureVisualizer pressure: 0.05 color: (Color blue alpha: 0.5)) kernel: (HGSimpleKernel support: 20)).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.05 width: 2 color: Color black) kernel: (HGSimpleKernel support: 20)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverBorderline [
	"HGSimulator impossibeRiverBorderline"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlinePressureVisualizer pressure: 0.4 width: 3 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Mesh'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverBorderlineFill [
	"HGSimulator impossibeRiverBorderlineFill"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Mesh'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverDots [
	"HGSimulator impossibeRiverDots"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color black).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River by Dots'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverGraffiti [
	"HGSimulator impossibeRiverGraffiti"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color blue).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 3 color: Color black)
				xgrids: 60;
				ygrids: 60;
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 4 color: Color black)
				xgrids: 50;
				ygrids: 50;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River (Graffiti)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverMesh [
	"HGSimulator impossibeRiverMesh"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			((HGMeshVelocityVisualizer new)).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Mesh'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverPerspectiveDots [
	"HGSimulator impossibeRiverPerspectiveDots"

	| simulator perspective |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveDotsVisualizer
				radius: 10
				color: Color blue
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 20 - (particle pressure * 10) max: -19 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River by Pseudo 3D Dots'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverPolygon [
	"HGSimulator impossibeRiverPolygon"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: Color lightBlue ).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Polygons'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverPressureMap [
	"HGSimulator impossibeRiverPressureMap"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Mesh'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverRefraction [
	"HGSimulator impossibeRiverRefraction"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBackgroundImageVisualizer form: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (HGMeshPressureVisualizer scale: 0.1 bias: 0.0 color: Color blue lighter).
	simulator addAction: (HGRefractionVisualizer scale: 10.0).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Mesh'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverSmokey [
	"HGSimulator impossibeRiverSmokey"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 25.0) scale: 20.0 color: (Color lightGray alpha: 0.3)).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River of Smokey Gas'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverSound [
	"HGSimulator impossibeRiverSound"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color black).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 100.0)
				kernel: (HGSimpleKernel support: 20.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator
		addAction:
			(HGCollisionPhonator at: 1 radius: 20.0 sound: (SampledSound samples: SampledSound coffeeCupClink samplingRate: 11025)).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River by Dots'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverVoronoi [
	"HGSimulator impossibeRiverVoronoi"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| diagram color1 color2 color3 |
					color1 := Color white mixed: 0.2 with: Color lightBlue.
					color2 := Color white mixed: 0.3 with: Color lightBlue.
					color3 := Color white mixed: 0.45 with: Color lightBlue.
					diagram := HGVoronoiDiagram new.
					simulator form getCanvas
						in: [ :canvas | 
							2 to: 101 do: [ :index | diagram addRegionAt: (simulator particleAt: index) position ].
							diagram
								origin: 0 @ 0
								corner: 500 @ 500
								pairsDo: [ :point1 :point2 | 
									| p1 p2 |
									p1 := point1 asPoint.
									p2 := point2 asPoint.
									canvas
										line: p1
										to: p2
										width: 14
										color: color1.
									canvas
										line: p1
										to: p2
										width: 5
										color: color2.
									canvas
										line: p1
										to: p2
										width: 1
										color: color3 ] ] ]).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Voronoi'.
	simulator color: Color lightBlue.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> impossibeRiverWireframe [
	"HGSimulator impossibeRiverWireframe"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGWireframeVisualizer width: 2 color: Color black).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Impossible River in Wireframes'.
	^ simulator
]

{ #category : #'applications-elastic' }
HGSimulator class >> jelloAtDie [
	"HGSimulator jelloAtDie"

	| simulator forms random trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction := HGSpringTrindingElasticForce k: 5.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)
				numberOfParticles: 200
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 8 color: Color yellow).
	simulator openInWindowLabeled: 'Jello at a Die'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-elastic' }
HGSimulator class >> jelloAtGun [
	"HGSimulator jelloAtGun"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction := HGSpringTrindingElasticForce k: 15.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 250 y: 100) radius: 100.0)
				numberOfParticles: 10
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint zero)).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					(simulator particleAt: 1)
						position: (HG2dPoint fromPoint: ActiveHand position - simulator position);
						velocity: (HG2dPoint x: 0.0 y: -20.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotVisualizer at: 1 radius: 2 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.0.
	simulator openInWindowLabeled: 'Jello at Gun'.
	simulator color: (Color lightGray ).
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> jelloAtMouse [
	"HGSimulator jelloAtMouse"

	| simulator forms random trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction := HGSpringTrindingElasticForce k: 5.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 100.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 100.0.
	simulator color: Color lightGray.
	simulator openInWindowLabeled: 'Jello at Mouse'.
	ActiveHand showTemporaryCursor: Cursor blank.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> jelloAtMouse2 [
	"HGSimulator jelloAtMouse2"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction := HGSpringTrindingElasticForce k: 15.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 100.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerAction
				when: [ (simulator particleAt: 1) position y between: 230 and: 270 ]
				action: (HGVelocityInitialization with: (HG2dPoint x: -2.0 y: 0.0))).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 100.0.
	simulator openInWindowLabeled: 'Jello at Mouse 2'.
	ActiveHand showTemporaryCursor: HGSimulator dot.
	simulator color: (Color lightGray).
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> jelloAtMouse3 [
	"HGSimulator jelloAtMouse3"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction := HGSpringTrindingElasticForce k: 15.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 100.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerAction
				when: [ (simulator particleAt: 1) position y between: 230 and: 270 ]
				action: (HGVelocityInitialization with: (HG2dPoint x: -4.0 y: 0.0))).
	simulator
		addAction:
			(HGTriggerBlockAction
				when: [ (simulator particleAt: 1) position x < 50.0 ]
				do: [ (simulator particleAt: 1) mass: 1000.0 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				when: [ (simulator particleAt: 1) position x < 50.0 ]
				do: [ simulator addAction: (HGCrusher at: 1 radius: 10.0 against: trindingElasticForceAction) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 500 @ 500 temperature: 390 mass: 100.0.
	simulator color: Color lightGray.
	simulator openInWindowLabeled: 'Jello at Mouse 3'.
	ActiveHand showTemporaryCursor: HGSimulator dot.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathDots [
	"HGSimulator jetbathDots"

	| simulator oldClicked clicked |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 2 color: (Color black)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	700 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'JetBath (Dots)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathGraffiti [
	"HGSimulator jetbathGraffiti"

	| simulator oldClicked clicked |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.1 color: Color lightBlue).
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.2 color: (Color lightBlue mixed: 0.95 with: Color blue)).
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.3 color: (Color lightBlue mixed: 0.9 with: Color blue)).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.1 width: 1 color: Color black)
				xgrids: 60;
				ygrids: 60;
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.1 width: 2 color: Color black)
				xgrids: 50;
				ygrids: 50;
				yourself).

	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	700 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'JetBath (Graffiti)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathPressureMap [
	"HGSimulator jetbathPressureMap"

	| simulator oldClicked clicked |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: ((HGMeshPressureVisualizer scale: 1.0 bias: 0.0 color: Color blue) kernel: (HGSimpleKernel support: 30)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	700 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'JetBath (PressureMap)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathRefraction [
	"HGSimulator jetbathRefraction"

	| simulator oldClicked clicked |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGRefractionVisualizer scale: 10.0 image: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	700 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'JetBath (Dots)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathSmoke [
	"HGSimulator jetbathSmoke"

	| simulator oldClicked clicked |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 20.0) scale: 50.0 color: (Color lightGray alpha: 0.3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	700 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'JetBath (Dots)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> jetbathSourceCode [
	"HGSimulator jetbathSourceCode"

	| simulator oldClicked clicked sourceStream |
	clicked := false.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 30.0
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGStringVisualizer color: (Color black) defaultString: ' ').
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	sourceStream := thisContext method getSource readStream.
	700 timesRepeat: [ (simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300) at: #string put: (String with: sourceStream next) ].
	simulator openInWindowLabeled: 'Jet Bath (Source Code)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonDots [
	"HGSimulator lagoonDots"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 2 color: (Color black)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Dots)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonGraffiti [
	"HGSimulator lagoonGraffiti"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.8 color: Color lightBlue).
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 1.2 color: (Color lightBlue mixed: 0.95 with: Color blue)).
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 1.6 color: (Color lightBlue mixed: 0.9 with: Color blue)).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.8 width: 1 color: Color black)
				xgrids: 60;
				ygrids: 60;
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.8 width: 2 color: Color black)
				xgrids: 50;
				ygrids: 50;
				yourself).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Graffiti)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPerspectiveDots [
	"HGSimulator lagoonPerspectiveDots"

	| simulator perspective |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveDotsVisualizer
				radius: 10
				color: Color blue
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 - (particle pressure * 3) max: -29 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed  ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Pseudo 3D Dots)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPerspectivePolygons [
	"HGSimulator lagoonPerspectivePolygons"

	| simulator perspective |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).	"simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm)."
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ (simulator particleAt: 1) position: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectivePolygonVisualizer
				color: Color blue
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 - (particle pressure * 3) max: -29 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective
								projectPoint: p - simulator position
								z: (10 - ((simulator particleAt: 1) pressure * 3) max: -29)
								in: simulator
								do: [ :x :y :z :a | 
									simulator form getCanvas
										in: [ :canvas | 
											canvas
												line: p - simulator position
												to: x @ y
												width: 5
												color: Color black ] ] ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Pseudo 3D Polygons)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPerspectiveStudDots [
	"HGSimulator lagoonPerspectiveStudDots"

	| simulator perspective1 perspective2 stick sweeping |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator color: Color white.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 300.0 y: 300.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 300 @ 300).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 100.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGTriggerAction
				whenever: [ sweeping ]
				action:
					(HGBumpyObstacle
						with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 80.0)
						color: nil)).
	sweeping := false.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective1 := HGPerspectiveDotsVisualizer
				radius: 18
				color: Color yellow muchDarker
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 ]
				colorBlock: [ :c :z | c ]).
	simulator
		addAction:
			(perspective2 := HGPerspectiveDotsVisualizer
				radius: 18
				color: Color yellow
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 - (particle pressure * 10) max: -29 ]
				colorBlock: [ :c :z | c ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective1 vanishingPoint: p - simulator position.
							perspective2 vanishingPoint: p - simulator position ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective1
								projectPoint: p - simulator position
								z: 10.0
								in: simulator
								do: [ :x :y :z :a | 
									simulator form getCanvas
										in: [ :canvas | 
											canvas
												line: p - simulator position
												to: x @ y
												width: 5
												color: Color black ] ] ] ]).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	Morph new
		extent: 1000 @ 500;
		changeTableLayout;
		listDirection: #rightToLeft;
		wrapCentering: #center;
		listCentering: #center;
		addMorph: simulator;
		openInWindowLabeled: 'Grease Tank (Studs)'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPerspectiveWireframe [
	"HGSimulator lagoonPerspectiveWireframe"

	| simulator perspective |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	"simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm)."
	simulator addAction: (HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [(simulator particleAt: 1) position: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveWireframeVisualizer 
				width: 2
				color: Color blue
				eyeHeight: 30
				vanishingPoint: 250 @ 250
				depthBlock: [ :sim :particle | 10 - (particle pressure * 3) max: -29 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ 
							perspective
								projectPoint: p - simulator position
								z: (10 - ((simulator particleAt: 1) pressure * 3) max: -29)
								in: simulator
								do: [ :x :y :z :a | 
									simulator form getCanvas
										in: [ :canvas | 
											canvas
												line: p - simulator position
												to: x @ y
												width: 5
												color: Color black ] ] ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed  ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Pseudo 3D Wireframe)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPolygons [
	"HGSimulator lagoonPolygons"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: (Color lightBlue mixed: 0.8 with: Color blue)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Polygon)'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPressureMap [
	"HGSimulator lagoonPressureMap"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: ((HGMeshPressureVisualizer color: Color blue) kernel: (HGSimpleKernel support: 30)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 4.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonPressureMapWorld [
	"HGSimulator lagoonPressureMapWorld"

	| random simulator |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGWorldSubmorphsObstacle withBoundsExpansion: 30).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: ((HGMeshPressureVisualizer color: Color blue) kernel: (HGSimpleKernel support: 30)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 4.0 color: Color red).
	simulator addAction: (HGDotVisualizer at: 2 radius: 4.0 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 3 radius: 4.0 color: Color yellow).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonReflectionWorld [
	"HGSimulator lagoonReflectionWorld"

	| random simulator |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGWorldSubmorphsObstacle withBoundsExpansion: 30).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGRefractionVisualizer scale: 1.0 image: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (HGReflectionVisualizer vector: (HG2dPoint x: 0.0 y: -0.7) color: Color yellow lighter muchLighter).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon Reflection World'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonRefractionWorld [
	"HGSimulator lagoonRefractionWorld"

	| random simulator |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGWorldSubmorphsObstacle withBoundsExpansion: 30).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGRefractionVisualizer scale: 10.0 image: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon Refraction World'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonSmokeyWorld [
	"HGSimulator lagoonSmokeyWorld"

	| random simulator |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGWorldSubmorphsObstacle withBoundsExpansion: 30).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 20.0) scale: 5.0 color: (Color lightGray alpha: 0.3)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon Refraction World'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonTilt [
	"HGSimulator lagoonTilt"

	| simulator gravity |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: ((ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0) * 4.0.
					g := g min: (HG2dPoint x: 4.0 y: 4.0) max: (HG2dPoint x: -4.0 y: -4.0).
					gravity g: g ]).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 60.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer color: Color blue muchLighter).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon Tilt'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonTiltRefraction [
	"HGSimulator lagoonTiltRefraction"

	| simulator gravity |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: ((ActiveHand position - simulator position) / simulator bounds extent * 0.5 - 0.25) * 4.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: g ]).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBackgroundImageVisualizer form: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (HGMeshPressureVisualizer scale: 0.1 bias: 0.0 color: Color blue lighter).
	simulator addAction: (HGRefractionVisualizer scale: 10.0).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon Tilt'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonVoronoi [
	"HGSimulator lagoonVoronoi"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color lightBlue.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| diagram color1 color2 color3 |
					color1 := Color white mixed: 0.2 with: Color lightBlue.
					color2 := Color white mixed: 0.3 with: Color lightBlue.
					color3 := Color white mixed: 0.45 with: Color lightBlue.
					diagram := HGVoronoiDiagram new.
					simulator form getCanvas
						in: [ :canvas | 
							2 to: 41 do: [ :index | diagram addRegionAt: (simulator particleAt: index) position ].
							diagram
								origin: 0 @ 0
								corner: 500 @ 500
								pairsDo: [ :point1 :point2 | 
									| p1 p2 |
									p1 := point1 asPoint.
									p2 := point2 asPoint.
									canvas
										line: p1
										to: p2
										width: 14
										color: color1.
									canvas
										line: p1
										to: p2
										width: 5
										color: color2.
									canvas
										line: p1
										to: p2
										width: 1
										color: color3 ] ] ]).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon (Voronoi)'.
	simulator color: Color lightBlue.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> lagoonWireframe [
	"HGSimulator lagoonWireframe"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGWireframeVisualizer width: 2 color: (Color black)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1200.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Lagoon(Wireframe)'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> lint1000 [
	"HGSimulator lint1000"

	| random  simulator bindingAction stick origin |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator particleMapResolution: 10.  
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := (HG2dPoint x: 250.0 y: 500.0).
	simulator addAction: (HGTriggerBlockAction whenever: [ActiveHand anyButtonPressed] do: [simulator particlesDo: [ :p | p addForce: (origin unitVector: p position) by: ((500000.0 / (origin to: stick center distance: p position) squared) min: 1000.0) ]]).
	simulator addAction: (HGPressure gasConstant: 1.0 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0  ).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 2.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle
				with:
					(stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0)
				color: (Color gray: 0.8)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ | position | position := ActiveHand position. (simulator bounds containsPoint: position) ifTrue: [stick center: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	50 timesRepeat: [
		| position p1 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		19 timesRepeat: [ | degrees p2 |
			degrees := random next * 360.
			p2 := simulator addParticleAt: (position := (Point r: 1 degrees: degrees) + position) temperature: nil mass: 300.
			bindingAction addBindingBetween: p1 and: p2.
			p1 := p2]].
	simulator openInWindowLabeled: 'Lint 1000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> lint2000 [
	"HGSimulator lint2000"

	| random simulator bindingAction stick origin |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (500000.0 / (origin to: stick center distance: p position) squared min: 1000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 1.0 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 2.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	100
		timesRepeat: [ 
			| position p1 |
			position := random next @ random next * 500.
			p1 := simulator addParticleAt: position temperature: nil mass: 300.
			19
				timesRepeat: [ 
					| degrees p2 |
					degrees := random next * 360.
					p2 := simulator addParticleAt: (position := (Point r: 1 degrees: degrees) + position) temperature: nil mass: 300.
					bindingAction addBindingBetween: p1 and: p2.
					p1 := p2 ] ].
	simulator openInWindowLabeled: 'Lint 2000'.
	^ simulator
]

{ #category : #'applications-bindings' }
HGSimulator class >> liquidOxgen [
	"HGSimulator liquidOxgen"

	| random  simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle
				with:
					(stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0)
				color: (Color gray: 0.8)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ | position | position := ActiveHand position. (simulator bounds containsPoint: position) ifTrue: [stick center: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 4 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	400 timesRepeat: [
		| position p1 p2 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		p2 := simulator addParticleAt: (Point r: 10 degrees: random next * 360) + position temperature: nil mass: 300.
		bindingAction addBindingBetween: p1 and: p2].
	simulator openInWindowLabeled: 'LiquidOxgen'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> meshVelocityViewer [
	"HGSimulator meshVelocityViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGMeshVelocityVisualizer new.
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Mesh-Velocity Viewer'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> nattoViewer [
	"HGSimulator nattoViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: (HGHandParticle at: 2).
	simulator addAction: (HGPVTUploader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGFormVisualizer natto.
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Beans Viewer'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> particlesVelocityViewer [
	"HGSimulator particlesVelocityViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator
		addAction:
			(HGParticlesVelocityVisualizer
				radius: 1.5
				width: 1.0
				scale: 10.0
				color: Color black).
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Particles-Velocity Viewer'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> polygonViewer [
	"HGSimulator polygonViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: Color blue).
	10 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Polygon Viewer'.
	^ simulator
]

{ #category : #'applications-bindings' }
HGSimulator class >> polymer10 [
	"HGSimulator polymer10"

	| random  simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle
				with:
					(stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0)
				color: (Color gray: 0.8)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ | position | position := ActiveHand position. (simulator bounds containsPoint: position) ifTrue: [stick center: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 4 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	80 timesRepeat: [
		| position p1 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		9 timesRepeat: [ | p2 |
			p2 := simulator addParticleAt: (position := (Point r: 10 degrees: random next * 360) + position) temperature: nil mass: 300.
			bindingAction addBindingBetween: p1 and: p2.
			p1 := p2]].
	simulator openInWindowLabeled: 'Polymer 10'.
	^ simulator
]

{ #category : #'applications-bindings' }
HGSimulator class >> polymer100 [
	"HGSimulator polymer100"

	| random  simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle
				with:
					(stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0)
				color: (Color gray: 0.8)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ | position | position := ActiveHand position. (simulator bounds containsPoint: position) ifTrue: [stick center: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 4 color: Color black).
	8 timesRepeat: [
		| position p1 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		99 timesRepeat: [ | degrees p2 |
			degrees := random next * 360.
			p2 := simulator addParticleAt: (position := (Point r: 10 degrees: degrees) + position) temperature: nil mass: 300.
			bindingAction addBindingBetween: p1 and: p2.
			p1 := p2]].
	simulator openInWindowLabeled: 'Polymer 100'.
	^ simulator
]

{ #category : #'applications-bindings' }
HGSimulator class >> polymer800 [
	"HGSimulator polymer800"

	| random  simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGFakeHand at: 1 mickey: 0.5 image: Cursor normal asCursorForm).
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray).
	simulator
		addAction:
			(HGObstacle
				with:
					(stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0)
				color: (Color gray: 0.8)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ | position | position := ActiveHand position. (simulator bounds containsPoint: position) ifTrue: [stick center: (HG2dPoint fromPoint: position - simulator position)]]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 4 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	1 timesRepeat: [
		| position p1 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		799 timesRepeat: [ | degrees p2 |
			degrees := random next * 360.
			p2 := simulator addParticleAt: (position := (Point r: 10 degrees: degrees) + position) temperature: nil mass: 300.
			bindingAction addBindingBetween: p1 and: p2.
			p1 := p2]].
	simulator openInWindowLabeled: 'Polymer 800'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> powder1000 [
	"HGSimulator powder1000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (500000.0 / (origin to: stick center distance: p position) squared min: 3000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 0.5 color: Color black).
	1000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'powder 1000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> powder2000 [
	"HGSimulator powder2000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (500000.0 / (origin to: stick center distance: p position) squared min: 3000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 0.5 color: Color black).
	2000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'powder 2000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> powder3000 [
	"HGSimulator powder3000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (500000.0 / (origin to: stick center distance: p position) squared min: 3000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 0.5 color: Color black).
	3000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'powder 3000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> powder4000 [
	"HGSimulator powder4000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator particleMapResolution: 10.  
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (500000.0 / (origin to: stick center distance: p position) squared min: 3000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 0.5 color: Color black).
	4000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'powder 4000'.
	^ simulator
]

{ #category : #'applications-constraints' }
HGSimulator class >> pressureMapInUserImage: rate [
	"HGSimulator pressureMapInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator
		addAction:
			(HGMeshPressureVisualizer scale: 1.0 bias: 0.0 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Pressure Map)'.
	^ simulator
]

{ #category : #copyrights }
HGSimulator class >> propagateLicense [
	"HGSimulator propagateLicense"

	(Smalltalk organization categoriesMatching: 'HoneyGinger-*')
		do: [ :classCategory | 
			(Smalltalk organization classesInCategory: classCategory)
				do: [ :c | 
					(c class selectors includes: #LICENSE)
						ifFalse: [ 
							c class compileSilently: 'LICENSE ^ self MITLicense' classified: 'copyrights'.
							c class reformatMethodAt: #LICENSE ].
					(c class selectors includes: #showLicense)
						ifTrue: [ 
							c class
								compileSilently:
									('showLicense\	(self LICENSE asText asMorph)\wrapFlag: true;\autoFit: false;\extent: 400 @ 400;\justified;\openInWindowLabeled: ''LICENSE''')
										withCRs
								classified: 'copyrights'.
							c class reformatMethodAt: #showLicense ].
					(c class selectors includes: #MITLicense)
						ifFalse: [ 
							c class
								compileSilently:
									'MITLicense ^ ''Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'' withCRs'
								classified: 'copyrights'.
							c class reformatMethodAt: #MITLicense ] ] ]
]

{ #category : #'applications-UI' }
HGSimulator class >> raftingDots [
	"HGSimulator raftingDots"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 3.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 250 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 600.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Rafting'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> raftingPolygons [
	"HGSimulator raftingPolygons"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 3.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 250 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: (Color lightBlue mixed: 0.8 with: Color blue)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 600.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Rafting'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> raftingPressureMap [
	"HGSimulator raftingPressureMap"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 3.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 250 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 mickey: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 600.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Rafting'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> raftingPressureSpeaker [
	"HGSimulator raftingPressureSpeaker"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 3.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 250 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator addAction: (HGStationaryPressureSpeaker kernel: (HGSimpleKernel support: 50.0)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 600.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Rafting'.
	^ simulator
]

{ #category : #'applications-bindings' }
HGSimulator class >> ramen [
	"HGSimulator ramen"

	| random  simulator stick bindingAction |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 9.8))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (bindingAction := HGHardBindingElasticForce steps: 4 convergenceCoefficient: 0.1 color: Color yellow muchLighter).
	bindingAction width: 5.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	50 timesRepeat: [
		| position p1 |
		position := random next @ random next * 500.
		p1 := simulator addParticleAt: position temperature: nil mass: 300.
		19 timesRepeat: [ | degrees p2 |
			degrees := random next * 360.
			p2 := simulator addParticleAt: (position := (Point r: 20 degrees: degrees) + position) temperature: nil mass: 300.
			bindingAction addBindingBetween: p1 and: p2.
			p1 := p2]].
	simulator openInWindowLabeled: 'Ramen'.
	simulator color: (Color gray: 0.9).
	^ simulator
]

{ #category : #'applications-constraints' }
HGSimulator class >> refractionMapInUserImage: rate [
	"HGSimulator refractionMapInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator addAction: (HGRefractionVisualizer scale: 20.0 image: (background form)).
	simulator
		addAction:
			(HGMeshPressureVisualizer scale: 1.0 bias: 0.0 color: (Color blue alpha: 0.1)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-elastic' }
HGSimulator class >> rockAtDie [
	"HGSimulator rockAtDie"

	| simulator forms random trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 50.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -10.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 10.0 y: 300.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 10.0 y: 200.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator openInWindowLabeled: 'Rock at Die Server'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-elastic' }
HGSimulator class >> rockAtGun [
	"HGSimulator rockAtGun"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: trindingElasticForceAction
				region: (HG2dCircle center: (HG2dPoint x: 100 y: 250) radius: 30.0)
				numberOfParticles: 10
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					(simulator particleAt: 1)
						position: (HG2dPoint fromPoint: ActiveHand position - simulator position);
						velocity: (HG2dPoint x: 0.0 y: -20.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotVisualizer at: 1 radius: 2 color: Color black).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 5000.0.
	simulator openInWindowLabeled: 'Rock at Gun'.
	simulator color: Color white.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> rockAtMouse [
	"HGSimulator rockAtMouse"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 50
				mass: 1000.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: trindingElasticForceAction
				region: (HG2dCircle center: (HG2dPoint x: 100 y: 250) radius: 30.0)
				numberOfParticles: 10
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 1000.0.
	simulator openInWindowLabeled: 'Rock at Mouse'.
	ActiveHand showTemporaryCursor: Cursor blank.
	simulator color: Color white.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> rockAtMouse2 [
	"HGSimulator rockAtMouse2"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 5 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 100
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				when: [ (simulator particleAt: 1) position y between: 230 and: 270 ]
				do: [ 2 to: simulator numberOfParticles do: [ :index | (simulator particleAt: index) velocity: (HG2dPoint x: -5.0 y: 0.0) ] ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 500 @ 500 temperature: 390 mass: 1000.0.
	simulator openInWindowLabeled: 'Rock at Mouse 2'.
	ActiveHand showTemporaryCursor: Cursor blank.
	simulator color: Color white.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> rockAtMouse3 [
	"HGSimulator rockAtMouse3"

	| simulator trindingElasticForceAction |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 5 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 100
				mass: 1000.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 270).
	simulator
		addAction:
			(HGTriggerBlockAction
				when: [ (simulator particleAt: 1) position y between: 230 and: 270 ]
				do: [ 2 to: simulator numberOfParticles do: [ :index | (simulator particleAt: index) velocity: (HG2dPoint x: -6.0 y: 0.0) ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				when: [ (simulator particleAt: 1) position x < 50.0 ]
				do: [ simulator addAction: (HGCrusher at: 1 radius: 10.0 against: trindingElasticForceAction) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: (HGFakeHand at: 1 image: Cursor normal asCursorForm).
	simulator addAction: HGLocalityMap new.
	simulator addParticleAt: 500 @ 500 temperature: 390 mass: 400.0.
	simulator openInWindowLabeled: 'Rock at Mouse 3'.
	ActiveHand showTemporaryCursor: Cursor blank.
	simulator color: Color white.
	^ simulator
]

{ #category : #'applications-elastic' }
HGSimulator class >> rockIce [
	"HGSimulator rockIce"

	| simulator trindingElasticForceAction1 trindingElasticForceAction2 |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 400 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction1 := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.5 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 400) radius: 50.0)
				numberOfParticles: 40
				mass: 1000.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction2 := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.5 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 100 y: 100) radius: 50.0)
				numberOfParticles: 40
				mass: 1000.0).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: trindingElasticForceAction1.
	simulator addAction: trindingElasticForceAction2.
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.2 kernel: (HGSimpleKernel support: 20.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 1.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: nil mass: 1000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'Rock Ice'.
	^ simulator
]

{ #category : #'applications-UI' }
HGSimulator class >> rocknjello [
	"HGSimulator rocknjello"

	| simulator bindingElasticForceAction trindingElasticForceAction1 trindingElasticForceAction2 picker |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on: (trindingElasticForceAction1 := HGSpringTrindingElasticForce k: 5.0 color: Color yellow)
				region: (HG2dCircle center: (HG2dPoint x: 100 y: 100) radius: 100.0)
				numberOfParticles: 10
				mass: 100.0).
	simulator addInitializer: HGLocalityMap new.
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addInitializer: (HGPressureInitialization with: 0.2).
	simulator addAction: (picker := HGParticleGripper within: 60.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.5)).
	simulator addAction: trindingElasticForceAction1.
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.5).
	simulator addAction: HGLocalityMap new.
	picker ifNotNil: [ simulator addAction: (HGParticlePickerVisualizer on: picker radius: 3.0 color: Color red) ].
	simulator addAction: (HGDotsVisualizer radius: 3 color: Color yellow).
	simulator openInWindowLabeled: 'Rock''n Jello'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> sandbox1000 [
	"HGSimulator sandbox1000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (50000.0 / (origin to: stick center distance: p position) squared min: 5000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							| p |
							p := HG2dPoint fromPoint: position - simulator position.
							(stick center distance: p) > 1.0
								ifTrue: [ p := p + (HG2dPoint theta: random next * Float pi * 2 r: random next * 2) ].
							stick center: p ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMassDotsVisualizer radius: 0.0015 color: Color black).
	1000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 600 * (random next * 0.5 + 0.5) ].
	simulator openInWindowLabeled: 'Sandbox 1000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> sandbox2000 [
	"HGSimulator sandbox2000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (50000.0 / (origin to: stick center distance: p position) squared min: 5000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							| p |
							p := HG2dPoint fromPoint: position - simulator position.
							(stick center distance: p) > 1.0
								ifTrue: [ p := p + (HG2dPoint theta: random next * Float pi * 2 r: random next * 2) ].
							stick center: p ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMassDotsVisualizer radius: 0.0015 color: Color gray).
	2000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 600 * (random next * 0.5 + 0.5) ].
	simulator openInWindowLabeled: 'Sandbox 2000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> sandbox3000 [
	"HGSimulator sandbox3000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (50000.0 / (origin to: stick center distance: p position) squared min: 5000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							| p |
							p := HG2dPoint fromPoint: position - simulator position.
							(stick center distance: p) > 1.0
								ifTrue: [ p := p + (HG2dPoint theta: random next * Float pi * 2 r: random next * 2) ].
							stick center: p ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMassDotsVisualizer radius: 0.0015 color: Color black).
	3000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 600 * (random next * 0.5 + 0.5) ].
	simulator openInWindowLabeled: 'Sandbox 3000'.
	^ simulator
]

{ #category : #'applications-zen' }
HGSimulator class >> sandbox4000 [
	"HGSimulator sandbox4000"

	| random origin simulator bindingAction stick |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					simulator
						particlesDo: [ :p | 
							p
								addForce: (origin unitVector: p position)
								by: (50000.0 / (origin to: stick center distance: p position) squared min: 5000.0) ] ]).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 25.0)).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 40.0) color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							| p |
							p := HG2dPoint fromPoint: position - simulator position.
							(stick center distance: p) > 1.0
								ifTrue: [ p := p + (HG2dPoint theta: random next * Float pi * 2 r: random next * 2) ].
							stick center: p ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMassDotsVisualizer radius: 0.0015 color: Color black).
	4000
		timesRepeat: [ 
			| position p |
			position := random next @ random next * 500.
			p := simulator addParticleAt: position temperature: nil mass: 600 * (random next * 0.5 + 0.5) ].
	simulator openInWindowLabeled: 'Sandbox 4000'.
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> sandtrap [
	"HGSimulator sandtrap"

	| random width origin simulator stick resetButton friction friction10 friction01 friction1 pressure grain1 grain2 grain3 frictionPanel grainPanel widthPanel randomPosition sweeping |
	sweeping := false.
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator particleMapResolution: 10.
	width := 10.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(randomPosition := HGRandomPosition origin: (250 - (width / 2.0)) @ 250 corner: (250 + (width / 2.0)) @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (pressure := HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: (friction := HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGBumpyObstacle
				with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0)
				color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 0.5 color: Color black).
	1000 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	resetButton := (SimpleButtonMorph newWithLabel: 'RESET')
		on: #mouseDown send: #value to: [ simulator setupSimulation ];
		yourself.
	frictionPanel := self selectorPanel: 'Friction' do: [ :mu | friction mu: mu asFloat ] withAll: #(0.1 1 10).
	grainPanel := self selectorPanel: 'Grain' do: [ :h | pressure kernel setSupport: h asFloat ] withAll: #(1 2 3).
	widthPanel := self
		selectorPanel: 'Width'
		do: [ :w | 
			randomPosition width: w.
			simulator setupSimulation ]
		withAll: #(1 5 10 20 50).
	(self
		verticalPanel:
			(Array
				with: resetButton
				with: frictionPanel
				with: grainPanel
				with: widthPanel))
		addMorph: simulator;
		openInWindowLabeled: 'sandtrap'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> sandtrap3D [
	"HGSimulator sandtrap3D"

	| random width origin simulator stick resetButton friction friction10 friction01 friction1 pressure grain1 grain2 grain3 frictionPanel grainPanel widthPanel randomPosition sweeping perspective |
	sweeping := false.
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator particleMapResolution: 10.
	width := 10.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(randomPosition := HGRandomPosition origin: (250 - (width / 2.0)) @ 150 corner: (250 + (width / 2.0)) @ 350).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	origin := HG2dPoint x: 250.0 y: 500.0.
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 3.0)).
	simulator addAction: (pressure := HGPressureRepulsion kernel: (HGSimpleKernel support: 3.0) maxPressure: 100.0).
	simulator addAction: (friction := HGFacialFriction mu: 10.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGBumpyObstacle
				with: (stick := HG2dSweep from: (HG2dPoint x: 0.0 y: 0.0) to: (HG2dPoint x: 0.0 y: 0.0) radius: 10.0)
				color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick from: stick to to: (HG2dPoint fromPoint: position - simulator position) ]
						ifFalse: [ sweeping := false ] ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ sweeping not ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ 
							stick
								from: (HG2dPoint fromPoint: position - simulator position)
								to: (HG2dPoint fromPoint: position - simulator position).
							sweeping := true ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(perspective := HGPerspectiveDotsVisualizer
				radius: 0.5
				color: Color black
				eyeHeight: 10
				vanishingPoint: 250 @ 500
				depthBlock: [ :sim :particle | particle pressure * -0.3 max: -9 ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ ActiveHand anyButtonPressed ]
				do: [ 
					| p |
					p := ActiveHand position.
					(simulator bounds containsPoint: p)
						ifTrue: [ perspective vanishingPoint: p - simulator position ] ]).
	1000 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	resetButton := (SimpleButtonMorph newWithLabel: 'RESET')
		on: #mouseDown send: #value to: [ simulator setupSimulation ];
		yourself.
	frictionPanel := self selectorPanel: 'Friction' do: [ :mu | friction mu: mu asFloat ] withAll: #(0.1 1 10).
	grainPanel := self selectorPanel: 'Grain' do: [ :h | pressure kernel setSupport: h asFloat ] withAll: #(1 2 3).
	widthPanel := self
		selectorPanel: 'Width'
		do: [ :w | 
			randomPosition width: w.
			simulator setupSimulation ]
		withAll: #(1 5 10 20 50).
	(self
		verticalPanel:
			(Array
				with: resetButton
				with: frictionPanel
				with: grainPanel
				with: widthPanel))
		addMorph: simulator;
		openInWindowLabeled: '3D sandtrap'.
	simulator
		setupSimulation;
		startStepping.
	^ simulator
]

{ #category : #utilities }
HGSimulator class >> selectorPanel: aString do: aBlock withAll: anArrayOfValues [
	| panel |
	panel := self horizontalPanel: (Array with: aString asMorph).
	anArrayOfValues do: [ :value |
		panel addMorph: ((SimpleButtonMorph newWithLabel: value asString)
			on: #mouseDown send: #value to: [ aBlock value: value])].
	^ panel
]

{ #category : #copyrights }
HGSimulator class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'applications-barriers' }
HGSimulator class >> silkyString1 [
	"HGSimulator silkyString1"

	| random simulator bindingAction stick resetBlock firsts lasts |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 10
				convergenceCoefficient: 0.1
				color: Color gray
				width: 4).
	bindingAction breakrate: 4.0.
	simulator addAction: (HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	resetBlock := [ 
	bindingAction removeBindingSuchThat: [ :binding | true ].
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	simulator clearParticles.
	250 to: 250 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 0.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		2 to: 500 by: 10 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 1) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ] ].
	resetBlock value.
	(self
		verticalPanel:
			(Array
				with:
					((SimpleButtonMorph newWithLabel: 'RESET')
						on: #mouseDown send: #value to: resetBlock;
						yourself)
				with:
					(self selectorPanel: 'Tension' do: [:steps | bindingAction steps: steps] withAll: #(1 2 5 10))
				with: (self selectorPanel: 'Strength' do: [ :rate | bindingAction breakrate: rate asFloat] withAll: #(3 4 5)))) 		 addMorph: simulator; openInWindowLabeled: 'Silky String 1'.
	simulator startStepping..

	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> silkyString5 [
	"HGSimulator silkyString5"

	| random simulator bindingAction stick firsts lasts resetBlock |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 10
				convergenceCoefficient: 0.1
				color: Color gray
				width: 1).
	bindingAction breakrate: 4.0.
	simulator addAction: (HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 20.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	resetBlock := [ 
	simulator clearParticles.
	bindingAction removeBindingSuchThat: [ :binding | true ].
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	240 to: 260 by: 4 do: [ :x | 
		| p1 last |
		p1 := simulator addParticleAt: x asFloat @ 0.0 temperature: nil mass: 300.
		firsts add: p1 -> p1 position copy.
		5 to: 500 by: 4 do: [ :y | 
			| p2 |
			last := simulator addParticleAt: x asFloat @ (y - 2) asFloat temperature: nil mass: 300.
			p2 := last.
			bindingAction addBindingBetween: p1 and: p2.
			p2 position: (HG2dPoint x: x asFloat y: y asFloat).
			p1 := p2 ].
		lasts add: last -> last position copy ] ].
	resetBlock value.
	(self
		verticalPanel:
			(Array
				with:
					((SimpleButtonMorph newWithLabel: 'RESET')
						on: #mouseDown send: #value to: resetBlock;
						yourself)
				with: (self selectorPanel: 'Tension' do: [ :steps | bindingAction steps: steps ] withAll: #(1 2 5 10))
				with: (self selectorPanel: 'Strength' do: [ :rate | bindingAction breakrate: rate asFloat ] withAll: #(3 4 5 10 20))))
		 addMorph: simulator; openInWindowLabeled: 'Silky String5'.
	simulator startStepping..
	^ simulator
]

{ #category : #'applications-barriers' }
HGSimulator class >> slackFence [
	"HGSimulator slackFence"

	| random simulator bindingAction stick firsts lasts showMap |
	random := Random new.
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	showMap := false.
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ showMap ]
				do: [ 
					(simulator form getCanvas)
						fillColor: Color yellow muchLighter;
						drawPolygon: (Array with: 0 @ 0 with: 250 @ 100 with: 500 @ 0)
							color: Color blue muchLighter
							borderWidth: 0
							borderColor: Color blue;
						drawPolygon:
								(Array
									with: 0 @ 0
									with: 0 @ 500
									with: 100 @ 400
									with: 250 @ 100)
							color: Color red muchLighter
							borderWidth: 0
							borderColor: Color red;
						drawPolygon: (Array with: 250 @ 100 with: 100 @ 400 with: 400 @ 350)
							color: Color green muchLighter
							borderWidth: 0
							borderColor: Color lightGray ]).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					firsts do: [ :assoc | assoc key position: assoc value ].
					lasts do: [ :assoc | assoc key position: assoc value ] ]).
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(bindingAction := HGHardBindingElasticForce
				steps: 20
				convergenceCoefficient: 0.1
				color: Color gray
				width: 4).
	simulator addAction: (HGObstacle with: (stick := HG2dCircle center: (HG2dPoint x: 0.0 y: 0.0) radius: 30.0) color: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ true ]
				do: [ 
					| position |
					position := ActiveHand position.
					(simulator bounds containsPoint: position)
						ifTrue: [ stick center: (HG2dPoint fromPoint: position - simulator position) ] ]).
	simulator addAction: (HGBoundingBox reflectionRate: 1.0).
	simulator addAction: HGLocalityMap new.
	firsts := OrderedCollection new.
	lasts := OrderedCollection new.
	(Array
		with: 250.0 @ 100.0
		with: 100.0 @ 400.0
		with: 400.0 @ 350.0
		with: 0.0 @ 0.0
		with: 500.0 @ 0.0
		with: 0.0 @ 500.0)
		with:
			(Array
				with: 100.0 @ 400.0
				with: 400.0 @ 350.0
				with: 250.0 @ 100.0
				with: 250.0 @ 100.0
				with: 250.0 @ 100.0
				with: 100.0 @ 400.0)
		do: [ :start :end | 
			| p1 v last step |
			p1 := simulator addParticleAt: start temperature: nil mass: 300.
			last := p1.
			v := end - start.
			firsts add: p1 -> p1 position copy.
			step := 10.0 / (start dist: end).
			step to: 1.0 by: step do: [ :t | 
				| p2 |
				p2 := simulator addParticleAt: v * (t - (step / 2.0)) + start temperature: nil mass: 300.
				bindingAction addBindingBetween: last and: p2.
				p2 position: (HG2dPoint fromPoint: v * t + start).
				last := p2 ].
			lasts add: last -> last position copy ].
	(self
		verticalPanel:
			(Array
				with: (self selectorPanel: 'Tension' do: [ :steps | bindingAction steps: steps ] withAll: #(1 5 10 20))
				with: (self selectorPanel: 'Map' do: [ :choice | showMap := choice = 'SHOW' ] withAll: #('SHOW' 'HIDE'))))
		addMorph: simulator;
		openInWindowLabeled: 'Slack Fence'.
	simulator startStepping.
	^ simulator
]

{ #category : #'applications-constraints' }
HGSimulator class >> smokeInUserImage: rate [
	"HGSimulator smokeInUserImage: 0.5"

	| form luminances border cursorForm simulator background gravity |
	form := Form fromDisplay: (0@0 corner: 50@50).
	luminances := OrderedCollection new: 2500.
	1 to: 50 do: [ :x | 1 to: 50 do: [ :y | luminances add: (form colorAt: x @ y) luminance ] ].
	border := luminances asSortedCollection at: ((2500 * rate) rounded min: 2500 max: 1).
	luminances := nil.
	cursorForm := Cursor normal asCursorForm.
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGViscosityInitialization with: 0.1).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: 500 @ 500).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [true]
				do: [ 
					| g |
					g := HG2dPoint fromPoint: (ActiveHand position - simulator position) / simulator bounds extent * 2.0 - 1.0.
					g := g min: (HG2dPoint x: 1.0 y: 1.0) max: (HG2dPoint x: -1.0 y: -1.0).
					gravity g: (g mul: 1.0) ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.1 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (background form colorAt: position asPoint) luminance < border ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.0).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (background := HGBackgroundImageVisualizer form: (form magnifyBy: 10)).
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 25.0) scale: 20.0 color: (Color black)).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	200 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Obstacles from User Image (Dots)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashDots [
	"HGSimulator splashDots"

	| simulator forms random |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.5 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Dots)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPolygon [
	"HGSimulator splashPolygon"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGPolygonVisualizer color: Color lightBlue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Polygons)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPressureBorderline [
	"HGSimulator splashPressureBorderline"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlinePressureVisualizer pressure: 0.4 width: 1 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Borderline)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPressureBorderlineFill [
	"HGSimulator splashPressureBorderlineFill"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color lightBlue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Borderline Fill)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPressureBorderlineGraffitiFill [
	"HGSimulator splashPressureBorderlineGraffitiFill"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color blue).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 3 color: Color black)
				xgrids: 60;
				ygrids: 60;
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 4 color: Color black)
				xgrids: 50;
				ygrids: 50;
				yourself).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Graffiti)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPressureBorderlineToonFill [
	"HGSimulator splashPressureBorderlineToonFill"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color blue).
	simulator addAction: (HGBorderlinePressureVisualizer pressure: 0.4 width: 3 color: Color black).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Toon)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashPressureMap [
	"HGSimulator splashPressureMap"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashRefraction [
	"HGSimulator splashRefraction"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBackgroundImageVisualizer form: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (HGMeshPressureVisualizer scale: 0.1 bias: 0.0 color: Color blue lighter).
	simulator addAction: (HGRefractionVisualizer scale: 10.0).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-flows' }
HGSimulator class >> splashSmoke [
	"HGSimulator splashSmoke"

	| simulator |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 150 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 25.0) scale: 20.0 color: (Color blue)).
	simulator addAction: (HGDotVisualizer at: 1 radius: 3.0 color: Color red).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	399 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Splash (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> stationaryVelocityViewer [
	"HGSimulator stationaryVelocityViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 1.0 color: Color black).
	simulator
		addAction:
			((HGStationaryVelocityVisualizer
				at: (HG2dPoint x: 250.0 y: 300.0)
				kernel: (HGSimpleKernel support: 50.0)
				radius: 2.0
				width: 2.0
				scale: 10.0
				color: Color brown)
				isTouchy: false;
				yourself).
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: nil mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Stationary-Velocity Viewer'.
	^ simulator
]

{ #category : #'applications-presentations' }
HGSimulator class >> steampaint [
	"HGSimulator steampaint"

	| random form mask simulator rate gravity window refraction smoke |
	random := Random new.
	form := Form
		fromBinaryStream:
			((UITheme current
				fileOpenIn: World
				title: 'Choose a file'
				extensions: #('png' 'jpg' 'bmp' 'gif')
				path: nil
				preview: #image) ifNil: [ ^ self ]).
	form := form scaledToSize: 500 @ (500 * form extent y / form extent x).
	rate := 1.0.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: form extent.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint fromPoint: form extent).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: form extent).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity
					g: (HG2dPoint x: 0 y: -2.0)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: HGLocalityMap withOutOfBoundsRemoval.
	simulator addAction: (HGBackgroundImageVisualizer form: form).
	simulator addAction: (smoke := HGSmokeyVisualizer kernel: (HGSimpleKernel support: 20.0) scale: 0.0 color: Color white).
	simulator
		addAction:
			(refraction := HGRefractionVisualizer
				xgrids: 60
				ygrids: 60
				kernel: (HGSimpleKernel support: 5)
				scale: 0.0
				image: nil).
	simulator
		addAction: (HGTriggerBlockAction
				whenever: [ActiveHand anyButtonPressed and: [simulator bounds containsPoint: ActiveHand position]]
				do: [ | point |
					point := ActiveHand position - simulator position.
					simulator addAction: (HGTriggerBlockAction whenever: [simulator random next < rate] do: [(simulator
								addParticleAt: simulator random next - 0.5 @ (simulator random next * 2.0 - 1.8) * 40 + point
								temperature: 370.0
								mass: 300.0)
								viscosity: 79.0])]).
	(self
		verticalPanel: (Array
				with: (self
						selectorPanel: 'Refraction'
						do: [:scale | 
							refraction scale: scale * 1.0]
						withAll: #(0 10 20 30 ))
				with: (self
						selectorPanel: 'Smoke'
						do: [:scale | 
							smoke scale: scale]
						withAll: #(0 100 200 300 ))
				with: (self
						selectorPanel: 'Upstream'
						do: [:gy | gravity g y: gy negated]
						withAll: #(0.1 0.2 0.5 1.0 2.0 4.0 8.0 ))
				with: (self
						selectorPanel: 'Amount'
						do: [:m | rate := m / 100.0]
						withAll: #(1 10 100)))) addMorphBack: simulator;
		 openInWindowLabeled: 'Steam-Paint'.
	simulator setupSimulation; startStepping.
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> stickyBeans [
	"HGSimulator stickyBeans"

	| simulator forms random |
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 300 @ 300 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.2 kernel: (HGSimpleKernel support: 15.0)).
	simulator
		addAction:
			(HGLocalAction
				on: (HGGravity g: (HG2dPoint x: 0 y: 1.0))
				in: (HG2dRectangle origin: (HG2dPoint fromPoint: 400 @ 0) corner: (HG2dPoint fromPoint: 500 @ 500))).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 15.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGFormVisualizer natto.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 400 mass: 300 ].
	simulator openInWindowLabeled: 'Sticky Beans'.
	^ simulator
]

{ #category : #'applications-viscous' }
HGSimulator class >> stickyBeansAtDie [
	"HGSimulator stickyBeansAtDie"

	| simulator |
	simulator := HGSimulator new.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGRandomPosition
				origin: 300 @ 150
				corner: 500 @ 350
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 100.0)).
	simulator addInitializer: (HGVelocityInitialization with: (HG2dPoint x: -20.0 y: 0.0)).
	simulator addInitializer: (HGTemperatureInitialization with: 360).
	simulator addAction: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0.0 y: 0.1)).
	simulator addAction: (HGPressure gasConstant: 0.01 kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 10.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 80.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 260.0) on: (HG2dPoint x: 200.0 y: 450.0) on: (HG2dPoint x: 50.0 y: 400.0))
				color: (Color gray: 0.8)).
	simulator
		addAction:
			(HGObstacle
				with:
					(HG2dTriangle on: (HG2dPoint x: 200.0 y: 240.0) on: (HG2dPoint x: 50.0 y: 100.0) on: (HG2dPoint x: 200.0 y: 30.0))
				color: (Color gray: 0.8)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: HGFormVisualizer natto.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 200.0 ].
	simulator openInWindowLabeled: 'Sticky Beans at a Die'.
	simulator color: (Color gray: 0.87).
	^ simulator
]

{ #category : #'applications-jun' }
HGSimulator class >> submarineByJun4Pharo [
	"HGSimulator submarineByJun4Pharo"

	| random form0 form1 form2 form rc1 rc2 ball ball2 a1 a2 r simulator contact |
	random := Random new.
	form0 := Form fromDisplay: (0@0 corner: 500@500).
	form1 := Form extent: form0 extent depth: form0 depth.
	form2 := Form extent: form0 extent depth: form0 depth.
	form := Form extent: form0 extent depth: form0 depth.
	rc1 := (Smalltalk at: #JunWodenRenderingContext) on: form1.
	rc1 projection: (JunPerspectiveProjection
		eyePoint: (0, 0, 10)
		sightPoint: 0, 0, 5
		upVector: 0 , 1, 0
		fovy: 30 asDegrees
		near: 0.1
		far: 10.0).
	rc1 disableCullface.
	rc1 ambientLight: Color darkGray.
	rc1 lightIndex: 0 parallel: (0.5, 0.3, 6.0) negated color: Color gray.
	rc2 := (Smalltalk at: #JunWodenRenderingContext) on: form2.
	rc2 projection: (JunPerspectiveProjection
		eyePoint: (0, 0, 10)
		sightPoint: 0, 0, 5
		upVector: 0 , 1, 0
		fovy: 30 asDegrees
		near: 0.1
		far: 5.0).
	rc2 disableCullface.
	rc2 ambientLight: Color darkGray.
	rc2 lightIndex: 0 parallel: (0.5, 0.3, 6.0) negated color: Color gray.
	ball := Jun3dDisplayObject sphere: 15 radius: 0.3.
	a1 := 0.0 asDegrees.
	a2 := 0.0 asDegrees.
	r := 2 * 3 sqrt / 5 * 250.
	contact := HG2dCircle center: (HG2dPoint x: 250.0 y: 250.0) radius: 0.0.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 200 @ 200 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.3 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 60.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ 
		| x y z |
		x := a1 cos.
		y := a1 sin.
		z := a2 sin * 0.5 + 4.5.
		a1 := a1 + 3 asDegrees.
		a2 := a2 + 7 asDegrees. 
		rc1 backgroundColor: (Color white).
		rc1 clear.
		rc1 backgroundColor: (Color transparent).
		rc1 clear.
		(ball2 := ball transform: (Jun3dTransformation translate: x, y, z)) renderOn: rc1.
		rc1 flush.
		contact center: (HG2dPoint fromPoint: x, y negated * r + 250).
		contact radius: (1.0 - (z - 5) abs * r * 0.7).
		form getCanvas drawImage: form0 at: 0@0; paintImage: form1 at: 0@0; flush]).
	simulator
		addAction:
			(HGObstacle
				with:
					(contact)
				color: (Color transparent)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGRefractionVisualizer scale: 10.0 image: (form)).
	simulator addAction: ((HGMeshPressureVisualizer color: Color blue) kernel: (HGSimpleKernel support: 60); scale:0.3).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [ 
		rc2 backgroundColor: (Color transparent).
		rc2 clear.
		ball2 renderOn: rc2.
		rc2 flush.
		simulator form getCanvas paintImage: form2 at: 0@0; flush]).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 3000.
	400 timesRepeat: [ simulator addParticleAt: 0 @ 0 temperature: 390 mass: 300 ].
	simulator openInWindowLabeled: 'Submarine'.
	^ simulator
]

{ #category : #utilities }
HGSimulator class >> verticalPanel: anArrayOfMorphs [
	| panel |
	panel := Morph new.
	panel color: Color white.
	panel changeTableLayout.
	panel listDirection: #bottomToTop.
	panel wrapCentering: #center.
	anArrayOfMorphs
		do: [ :morph | 
			panel addMorph: morph.
			morph hResizing: #spaceFill ].
	^ panel
]

{ #category : #'applications-watershows' }
HGSimulator class >> washoutDots [
	"HGSimulator washoutDots"

	| source random simulator clicked oldClicked trindingElasticForceAction |
	source := thisContext method getSource.
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 20
				mass: 200.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGPump
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 10.0
								at: (p)) ]).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 1.0 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.9).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 3 color: Color blue).
	simulator openInWindowLabeled: 'Washout (Dots)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> washoutPressureMap [
	"HGSimulator washoutPressureMap"

	| source random simulator clicked oldClicked trindingElasticForceAction |
	source := thisContext method getSource.
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 20
				mass: 200.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGPump
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 10.0
								at: (p)) ]).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.9).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator addAction: trindingElasticForceAction.
	simulator openInWindowLabeled: 'Washout (Dots)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> washoutRefraction [
	"HGSimulator washoutRefraction"

	| source random simulator clicked oldClicked trindingElasticForceAction |
	source := thisContext method getSource.
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addInitializer:
			(HGAddTrindingElasticBody
				on:
					(trindingElasticForceAction := HGHardTrindingElasticForce steps: 3 convergenceCoefficient: 0.1 color: Color gray)
				region: (HG2dCircle center: (HG2dPoint x: 400 y: 250) radius: 80.0)
				numberOfParticles: 20
				mass: 200.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGPump
								v: (p unitVector: (HG2dPoint x: 250.0 y: 250.0)) * 10.0
								at: (p)) ]).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 1.0 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGRefractionVisualizer scale: 3.0 image: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: trindingElasticForceAction.
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.9).
	simulator addAction: HGLocalityMap new.
	simulator openInWindowLabeled: 'Washout (Refraction)'.
	^ simulator
]

{ #category : #'applications-distributed-viewers' }
HGSimulator class >> waterImageViewer [
	"HGSimulator waterImageViewer"

	| simulator |
	simulator := HGSimulator new.
	simulator color: Color white.
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addAction: (HGPVTDownloader address: #[127 0 0 1] port: 9800).
	simulator addAction: HGFormVisualizer water.
	10
		timesRepeat: [ 
			simulator
				addParticleAt: 0 @ 0
				temperature: nil
				mass: 300 ].
	simulator openInWindowLabeled: 'HoneyGinger Water Viewer'.
	^ simulator
]

{ #category : #'applications-presentations' }
HGSimulator class >> waterpaint [
	"HGSimulator waterpaint"

	| random form mask simulator gravity window |
	random := Random new.
	form := Form
		fromBinaryStream:
			((UITheme current
				fileOpenIn: World
				title: 'Choose a file'
				extensions: #('png' 'jpg' 'bmp' 'gif')
				path: nil
				preview: #image) ifNil: [ ^ self ]).
	form := form scaledToSize: 500 @ (500 * form extent y / form extent x).
	mask := Form extent: form extent depth: 1.
	mask getCanvas fillColor: Color white.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: form extent.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint fromPoint: form extent).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: form extent).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (mask colorAt: position asPoint) luminance > 0.5 ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBackgroundImageVisualizer form: form).
	simulator
		addAction:
			(HGRefractionVisualizer
				xgrids: 100
				ygrids: 100
				kernel: (HGSimpleKernel support: 40)
				scale: 10.0
				image: nil).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ random next < 0.1 ]
				do: [ gravity g: (HG2dPoint theta: random next * 3.14 * 2 r: 0.1) ]).
	simulator addAction: (HGTriggerBlockAction
		whenever: [ActiveHand anyButtonPressed and: [simulator bounds containsPoint: ActiveHand position ]] do: [
			| point |
			point := ActiveHand position - simulator position.
			mask getCanvas fillOval: (point - 20 extent: 41) color: Color black; flush.
			simulator random next < 0.3 ifTrue: [(simulator addParticleAt: point temperature: 370.0 mass: 300.0) viscosity: 79.0  ]]).
	simulator
		setupSimulation;
		startStepping.
	window := simulator openInWindowLabeled: 'Water-Paint'.
	^ simulator
]

{ #category : #'applications-presentations' }
HGSimulator class >> waterpaintFromUser [
	"HGSimulator waterpaintFromUser"

	| random form mask simulator gravity window |
	random := Random new.
	form := Form
		fromUser.
	form ifNil: [^self].
	form := form scaledToSize: 500 @ (500 * form extent y / form extent x).
	mask := Form extent: form extent depth: 1.
	mask getCanvas fillColor: Color white.
	simulator := HGSimulator new.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: form extent.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint fromPoint: form extent).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 0 corner: form extent).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 370).
	simulator addInitializer: HGTemperatureViscosityCurve butter.
	simulator addAction: (HGPositionNoise withBlock: [ random next @ random next * 0.01 ]).
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (gravity := HGGravity g: (HG2dPoint x: 0.0 y: 0.0)).
	simulator addAction: (HGPressure gasConstant: 0.7 kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator
		addAction:
			(HGObstacle with: (HG2dBlockRegion on: [ :position | (mask colorAt: position asPoint) luminance > 0.5 ])).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator
		addAction:
			(HGRefractionVisualizer
				xgrids: 100
				ygrids: 100
				kernel: (HGSimpleKernel support: 40)
				scale: 15.0
				image: form).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ random next < 0.1 ]
				do: [ gravity g: (HG2dPoint theta: random next * 3.14 * 2 r: 0.1) ]).
	simulator addAction: (HGTriggerBlockAction
		whenever: [ActiveHand anyButtonPressed and: [simulator bounds containsPoint: ActiveHand position ]] do: [
			| point |
			point := ActiveHand position - simulator position.
			mask getCanvas fillOval: (point - 20 extent: 41) color: Color black; flush.
			simulator random next < 0.2 ifTrue: [(simulator addParticleAt: point temperature: 370.0 mass: 300.0) viscosity: 79.0  ]]).
	simulator
		setupSimulation;
		startStepping.
	window := simulator openInWindowLabeled: 'Water-Paint'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowDots [
	"HGSimulator watershowDots"

	| random simulator clicked oldClicked |
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: 10.0 y: -20.0) at: (HG2dPoint x: 10.0 y: 200.0)).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	"simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction HGVelocityIntegration new."
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGDotsVisualizer radius: 3.0 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Watershow (Dots)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowGraffiti [
	"HGSimulator watershowGraffiti"

	| random simulator clicked oldClicked |
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: 10.0 y: -20.0) at: (HG2dPoint x: 10.0 y: 200.0)).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	"simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction HGVelocityIntegration new."
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBorderlineFillPressureVisualizer pressure: 0.4 color: Color blue).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 3 color: Color black)
				xgrids: 60;
				ygrids: 60;
				yourself).
	simulator
		addAction:
			((HGBorderlinePressureVisualizer pressure: 0.4 width: 4 color: Color black)
				xgrids: 50;
				ygrids: 50;
				yourself).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Watershow (Graffiti)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowPressureMap [
	"HGSimulator watershowPressureMap"

	| random simulator clicked oldClicked |
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: 10.0 y: -20.0) at: (HG2dPoint x: 10.0 y: 200.0)).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	"simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction HGVelocityIntegration new."
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGMeshPressureVisualizer scale: 0.2 bias: 0.0 color: Color blue).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Watershow (Pressure Map)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowRefraction [
	"HGSimulator watershowRefraction"

	| random simulator clicked oldClicked |
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: 10.0 y: -20.0) at: (HG2dPoint x: 10.0 y: 200.0)).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	"simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGViscosityTraction kernel: (HGSimpleKernel support: 70.0)).
	simulator addAction: HGForceIntegration new.
	simulator addAction HGVelocityIntegration new."
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGBackgroundImageVisualizer form: (Form fromDisplay: (0@0 corner: 500@500))).
	simulator addAction: (HGMeshPressureVisualizer scale: 0.05 bias: 0.0 color: Color blue lighter).
	simulator addAction: (HGRefractionVisualizer scale: 10.0).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Watershow (Dots)'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowSmoke [
	"HGSimulator watershowSmoke"

	| random simulator clicked oldClicked |
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator addInitializer: (HGRandomPosition origin: 0 @ 400 corner: 500 @ 500).
	simulator addInitializer: (HGVelocityInitialization with: HG2dPoint zero).
	simulator addInitializer: (HGTemperatureInitialization with: 380).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: 10.0 y: -20.0) at: (HG2dPoint x: 10.0 y: 200.0)).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 50.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.098)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 20.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 30.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGSmokeyVisualizer kernel: (HGSimpleKernel support: 20.0) scale: 5.0 color: Color lightGray).
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Smoke show'.
	^ simulator
]

{ #category : #'applications-watershows' }
HGSimulator class >> watershowSourceCode [
	"HGSimulator watershowSourceCode"

	| source random simulator clicked oldClicked |
	source := thisContext method getSource.
	random := Random new.
	simulator := HGSimulator new.
	clicked := false.
	simulator color: ((Color brown mixed: 0.4 with: Color gray) alpha: 0.2).
	simulator extent: 500 @ 500.
	simulator simulationOrigin: (HG2dPoint x: 0.0 y: 0.0) corner: (HG2dPoint x: 500.0 y: 500.0).
	simulator
		addAction:
			(HGTriggerBlockAction
				whenever: [ 
					oldClicked := clicked.
					clicked := ActiveHand anyButtonPressed.
					oldClicked not and: [ clicked ] ]
				do: [ 
					| p d |
					p := HG2dPoint fromPoint: ActiveHand position - simulator position.
					d := HG2dPoint x: 20.0 y: 20.0.
					simulator
						addAction:
							(HGJet
								v: (HG2dPoint x: (250 - p x) / 20 y: -25)
								in: (HG2dRectangle origin: p - d corner: p + d)) ]).
	simulator addAction: (HGPump v: (HG2dPoint x: -10.0 y: -20.0) at: (HG2dPoint x: 490.0 y: 200.0)).
	simulator addAction: (HGTriggerBlockAction whenever: [true] do: [(simulator particleAt: (simulator numberOfParticles)) ifNotNilDo: [ : p | p at: #string put: (String with: (source at: (simulator numberOfParticles \\ source size + 1)))]]).
	simulator addAction: (HGHandParticle at: 1).
	simulator addAction: HGTemperatureViscosityCurve normalizedButter.
	simulator addAction: (HGForceInitialization with: HG2dPoint zero).
	simulator addAction: (HGPressure gasConstant: 0.5 kernel: (HGSimpleKernel support: 20.0)).
	simulator addAction: (HGGravity g: (HG2dPoint x: 0 y: 0.98)).
	simulator addAction: (HGPressureRepulsion kernel: (HGSimpleKernel support: 5.0) maxPressure: 1000.0).
	simulator addAction: HGForceIntegration new.
	simulator addAction: HGVelocityIntegration new.
	simulator addAction: (HGViscosityBySmoothing kernel: (HGSimpleKernel support: 40.0)).
	simulator addAction: (HGBoundingBox reflectionRate: 0.1).
	simulator addAction: HGLocalityMap new.
	simulator addAction: (HGStringVisualizer color: Color blue defaultString: 'O').
	simulator addParticleAt: 0 @ 0 temperature: 390 mass: 2000.
	simulator openInWindowLabeled: 'Watershow (SourceCode)'.
	^ simulator
]

{ #category : #rules }
HGSimulator >> addAction: anHGAction [
	actions add: anHGAction
]

{ #category : #rules }
HGSimulator >> addInitializer: anHGRule [
	initializers add: anHGRule
]

{ #category : #particles }
HGSimulator >> addParticleAt: aPoint temperature: temperature mass: mass [
	| particle |
	particle := HGParticle
		at: (HG2dPoint fromPoint: aPoint)
		velocity: HG2dPoint zero
		temperature: temperature
		mass: mass
		in: self.
	particles := particles copyWith: particle.
	^ particle
]

{ #category : #particles }
HGSimulator >> clearParticles [
	particles := Array new.
	self updateParticleMap
]

{ #category : #accessing }
HGSimulator >> color: aColor [
	super color: aColor.
	form ifNotNil: [ form getCanvas fillColor: self color ].
	visibleForm ifNotNil: [ visibleForm getCanvas fillColor: self color ]
]

{ #category : #fields }
HGSimulator >> countAt: anHG2dPoint kernel: anHGKernel [
	| count |
	count := 0.
	self
		neighborsOf: anHG2dPoint
		within: anHGKernel support
		do: [ :neighbor :distance | count := count + (anHGKernel r: distance) ].
	^ count
]

{ #category : #drawing }
HGSimulator >> drawOn: aCanvas [
	visibleForm ifNotNilDo: [ :f | aCanvas drawImage: f at: self position sourceRect: (0 @ 0 extent: self extent) ]
]

{ #category : #accessing }
HGSimulator >> form [
	^form
]

{ #category : #'event handling' }
HGSimulator >> handlerForBlueButtonDown: anEvent [
	^ nil  
]

{ #category : #'event handling' }
HGSimulator >> handlesMouseDown: anEvent [
	^(super handlesMouseDown: anEvent) or: [anEvent redButtonPressed]  
]

{ #category : #'initialize-release' }
HGSimulator >> initialize [
	super initialize.
	actions := OrderedCollection new.
	initializers := OrderedCollection new.
	particles := Array new.
	particleMapResolution := 50.
	random := Random new.
	self updateParticleMap.

]

{ #category : #enumerating }
HGSimulator >> neighborsOf: anHG2dPoint within: aNumber do: aBlock [
	| x y r |
	x := anHG2dPoint x.
	y := anHG2dPoint y.
	r := aNumber squared.
	particleMap
		at: anHG2dPoint
		within: aNumber
		do: [ :particle | 
						| p dx dy |
			p := particle position.
			dx := x - p x.
			((dx := dx * dx) < r
				and: [ 
					dy := y - p y.
					(dy := dy * dy) < r ])
				ifTrue: [ 
					| d |
					(d := dx + dy) < r
						ifTrue: [ aBlock value: particle value: d sqrt ] ] ]
]

{ #category : #accessing }
HGSimulator >> numberOfParticles [
	^ particles size
]

{ #category : #'user interface' }
HGSimulator >> openInWindowLabeled: aString [
	| window |
	window := super openInWindowLabeled: aString.
	self setupSimulation.
	^ window
]

{ #category : #'user interface' }
HGSimulator >> openInWorld [
	| window |
	window := super openInWorld.
	self setupSimulation.
	^ window
]

{ #category : #accessing }
HGSimulator >> particleAt: anInteger [
	^ particles at: anInteger ifAbsent: []
]

{ #category : #accessing }
HGSimulator >> particleMapResolution [
	^ particleMapResolution
]

{ #category : #accessing }
HGSimulator >> particleMapResolution: anInteger [
	particleMapResolution := anInteger.
	self updateParticleMap 
]

{ #category : #enumerating }
HGSimulator >> particlesDo: aBlock [
	particles do: aBlock
]

{ #category : #accessing }
HGSimulator >> random [
	^ random
]

{ #category : #rules }
HGSimulator >> removeAction: anHGAction ifAbsent: errorBlock [
	^ actions remove: anHGAction ifAbsent: errorBlock
]

{ #category : #particles }
HGSimulator >> removeParticlesSuchThat: aBlock [
	particles := particles reject: aBlock.
	self updateParticleMap
]

{ #category : #'stepping and presenter' }
HGSimulator >> setupSimulation [
	self setupSimulationAt: Time millisecondClockValue
]

{ #category : #'stepping and presenter' }
HGSimulator >> setupSimulationAt: millisecondClockValue [
	"| time |
	time := self timeFromMillis: millisecondClockValue.
	self particlesDo: [ :particle | particle setupState: time ]"

	simulationTime := self timeFromMillis: millisecondClockValue.
	initializers do: [ :rule | rule effectIn: self deltaT: 0.0 ]
]

{ #category : #copyrights }
HGSimulator >> showLicense [
	self class showLicense
]

{ #category : #accessing }
HGSimulator >> simulationCorner [
	^simulationCorner
]

{ #category : #accessing }
HGSimulator >> simulationOrigin [
	^ simulationOrigin
]

{ #category : #accessing }
HGSimulator >> simulationOrigin: anHG2dPoint corner: anotherHG2dPoint [
	simulationOrigin := anHG2dPoint.
	simulationCorner := anotherHG2dPoint.
	form := Form extent: (anotherHG2dPoint x - anHG2dPoint x) @ (anotherHG2dPoint y - anHG2dPoint y) depth: 32.
	form getCanvas fillColor: self color.
	visibleForm := Form extent: (anotherHG2dPoint x - anHG2dPoint x) @ (anotherHG2dPoint y - anHG2dPoint y) depth: 32.
	visibleForm getCanvas fillColor: self color.
	self updateParticleMap
]

{ #category : #accessing }
HGSimulator >> simulationTime [
	^ simulationTime
]

{ #category : #'stepping and presenter' }
HGSimulator >> step [
	self stepAt: Time millisecondClockValue 
]

{ #category : #'stepping and presenter' }
HGSimulator >> stepAt: millisecondClockValue [
	| time deltaT |
	"deltaT := (time := self timeFromMillis: millisecondClockValue) - simulationTime."
	deltaT := 1.0.
	actions do: [ :rule | rule effectIn: self deltaT: deltaT ].
	self updateForm.
	simulationTime := time.
	self invalidRect: self fullBounds
]

{ #category : #'stepping and presenter' }
HGSimulator >> stepTime [
	^10.0
]

{ #category : #accessing }
HGSimulator >> time [
	^ self timeFromMillis: Time millisecondClockValue
]

{ #category : #accessing }
HGSimulator >> timeFromMillis: aNumber [
	^ aNumber / 200.0.
]

{ #category : #accessing }
HGSimulator >> updateForm [
	| t |
	t := visibleForm.
	visibleForm := form.
	form := t.
	(form getCanvas)
		fillColor: self color;
		flush
]

{ #category : #particles }
HGSimulator >> updateParticleMap [
	(simulationOrigin notNil and: [ simulationCorner notNil ])
		ifTrue: [ 
			| newParticleMap |
			newParticleMap := HGSpatialPartitionedCollection origin: simulationOrigin corner: simulationCorner step: particleMapResolution.
			self particlesDo: [ :particle | newParticleMap at: particle position add: particle ].
			particleMap := newParticleMap ]
]

{ #category : #fields }
HGSimulator >> velocityAt: anHG2dPoint kernel: anHGKernel [
	| velocity denominator |
	velocity := HG2dPoint zero.
	denominator := 0.0.
	self
		neighborsOf: anHG2dPoint
		within: anHGKernel support
		do: [ :neighbor :distance | 
			| r |
			r := anHGKernel r: distance.
			velocity add: neighbor velocity by: r.
			denominator := denominator + r ].
	^ denominator > 0.0
		ifTrue: [ velocity / denominator ]
		ifFalse: [ velocity ]
]
