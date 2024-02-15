Class {
	#name : 'HGVoronoiDiagram',
	#superclass : 'Object',
	#instVars : [
		'random',
		'distribution',
		'regions',
		'edges'
	],
	#category : 'HoneyGinger-Geometry-Voronoi',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Voronoi'
}

{ #category : 'examples' }
HGVoronoiDiagram class >> exampleVoronoiDiagram [

	"HGVoronoiDiagram exampleVoronoiDiagram"

	| random form diagram |
	random := Random new.
	form := Form extent: 500 @ 500 depth: 32.
	diagram := HGVoronoiDiagram new.
	200 timesRepeat: [ 
		| p |
		p := random next @ random next * 500.
		diagram addRegionAt: p ].
	form getCanvas ifNotNil: [ :canvas | 
		canvas fillColor: Color lightBlue.
		diagram origin: 0 @ 0 corner: 500 @ 500 pairsDo: [ :p1 :p2 | 
			canvas
				line: p1 x @ p1 y
				to: p2 x @ p2 y
				width: 10
				color: (Color white alpha: 0.02).
			canvas
				line: p1 x @ p1 y
				to: p2 x @ p2 y
				width: 5
				color: (Color white alpha: 0.02).
			canvas
				line: p1 x @ p1 y
				to: p2 x @ p2 y
				width: 1
				color: (Color white alpha: 0.1) ]
		"diagram regionsDo: [ :region | canvas fillOval: (region center asPoint extent: 1 @ 1) color: Color red ]" ].
	form asMorph openInWindowLabeled: 'Voronoi'.
	^ diagram
]

{ #category : 'examples' }
HGVoronoiDiagram class >> exampleVoronoiMap [

	"HGVoronoiDiagram exampleVoronoiMap"

	| random form diagram |
	random := Random new.
	form := Form extent: 500 @ 500 depth: 32.
	diagram := HGVoronoiDiagram new.
	400 timesRepeat: [ 
		| p |
		p := random next @ random next * 500.
		diagram addRegionAt: p ].
	form getCanvas ifNotNil: [ :canvas | 
		canvas fillColor: Color white.
		diagram regionsDo: [ :region | 
			| points |
			points := OrderedCollection new: 10.
			region
				origin: 0 @ 0
				corner: 500 @ 500
				pointsDo: [ :p | points add: p asPoint ].
			canvas
				drawPolygon: points
				color: Color random
				borderWidth: 0
				borderColor: Color black ].
		diagram origin: 0 @ 0 corner: 500 @ 500 pairsDo: [ :p1 :p2 | 
			canvas
				line: p1 x @ p1 y
				to: p2 x @ p2 y
				width: 1
				color: Color black ].
		diagram regionsDo: [ :region | 
			canvas
				fillOval: (region center asPoint extent: 1 @ 1)
				color: Color red ] ].
	form asMorph openInWindowLabeled: 'Voronoi Map'.
	^ diagram
]

{ #category : 'examples' }
HGVoronoiDiagram class >> exampleVoronoiPlotter [

	"HGVoronoiDiagram exampleVoronoiPlotter"

	| random hueStep hueStream hueBlock imageMorph diagram colorDict plotter |
	random := Random new.
	hueStep := 360.0.
	hueStream := (hueStep / 2.0 to: 360.0 by: hueStep) asArray readStream.
	hueBlock := [ 
	            hueStream atEnd ifTrue: [ 
		            hueStep := hueStep / 2.0.
		            hueStream := (hueStep / 2.0 to: 360.0 by: hueStep)
			                         asArray readStream ].
	            hueStream next ].
	imageMorph := (Form extent: 500 @ 500 depth: 32) asMorph.
	diagram := HGVoronoiDiagram new.
	colorDict := IdentityDictionary new.
	imageMorph on: #mouseDown send: #value to: [ 
		Transcript
			cr;
			show: World activeHand position printString.
		colorDict
			at:
			(diagram addRegionAt:
				 World activeHand position - imageMorph position)
			put: (Color h: hueBlock value s: 1.0 v: 1.0).
		imageMorph form getCanvas ifNotNil: [ :canvas | 
			canvas fillColor: Color white.
			diagram regionsDo: [ :region | 
				| points |
				points := OrderedCollection new: 10.
				region
					origin: 0 @ 0
					corner: 500 @ 500
					pointsDo: [ :p | points add: p asPoint ].
				canvas
					drawPolygon: points
					color: (colorDict at: region)
					borderWidth: 0
					borderColor: Color black ].
			diagram regionsDo: [ :region | 
				canvas
					fillOval: (region center asPoint - 2 extent: 4 @ 4)
					color: Color black ].
			imageMorph changed ] ].
	plotter := Morph new.
	plotter changeTableLayout.
	plotter listDirection: #bottomToTop.
	plotter wrapCentering: #center.
	plotter addMorph: imageMorph.
	plotter openInWindowLabeled: 'Voronoi Plotter'
]

{ #category : 'adding' }
HGVoronoiDiagram >> addRegionAt: aPoint [
	| thePoint newRegion |
	thePoint := HG2dPoint x: aPoint x asFloat y: aPoint y asFloat.
	newRegion := HGVoronoiRegion at: thePoint.
	(self regionThatContains: thePoint)
		ifNotNil: [ :region | 
			| agenda done |
			agenda := OrderedCollection with: region.
			done := OrderedCollection with: region with: newRegion.
			[ agenda notEmpty ]
				whileTrue: [ | currentRegion |
					currentRegion := agenda removeLast.
					(currentRegion
						cutAgainst: newRegion
						conflictEdgesDo: [ :newEdge :edge | 
							| nextRegion |
							nextRegion := edge theOtherSide: currentRegion.
							(done includes: nextRegion)
								ifFalse: [ done add: nextRegion.
									agenda add: nextRegion ] ])
						ifNotNil: [ :newEdge | edges add: newEdge ] ].
			done
				do: [ :affected | affected purgeExtraEdges do: [ :e | edges remove: e ] ] ].
	^ regions add: newRegion
]

{ #category : 'enumerating' }
HGVoronoiDiagram >> edgesDo: aBlock [
	edges do: aBlock
]

{ #category : 'initialize-release' }
HGVoronoiDiagram >> initialize [
	super initialize.
	regions := OrderedCollection new.
	edges := OrderedCollection new.
	random := Random new.
	distribution := 1.0
]

{ #category : 'enumerating' }
HGVoronoiDiagram >> origin: aPoint1 corner: aPoint2 pairsDo: aTwoArgumentBlock [
	| x1 x2 y1 y2 |
	x1 := aPoint1 x.
	x2 := aPoint2 x.
	y1 := aPoint1 y.
	y2 := aPoint2 y.
	self
		edgesDo: [ :edge | 
			| from to |
			from := edge fromT.
			to := edge toT.
			(edge tAtX: x1)
				ifNotNil: [ :t | 
					edge vector x > 0.0
						ifTrue: [ from := from max: t ]
						ifFalse: [ to := to min: t ] ].
			(edge tAtY: y1)
				ifNotNil: [ :t | 
					edge vector y > 0.0
						ifTrue: [ from := from max: t ]
						ifFalse: [ to := to min: t ] ].
			(edge tAtX: x2)
				ifNotNil: [ :t | 
					edge vector x > 0.0
						ifTrue: [ to := to min: t ]
						ifFalse: [ from := from max: t ] ].
			(edge tAtY: y2)
				ifNotNil: [ :t | 
					edge vector y > 0.0
						ifTrue: [ to := to min: t ]
						ifFalse: [ from := from max: t ] ].
			(from <= to and: [ from isInfinite not and: [ to isInfinite not ] ])
				ifTrue: [ | fromPoint toPoint |
					fromPoint := edge atT: from.
					toPoint := edge atT: to.
					((fromPoint x between: x1 and: x2)
						and: [ (toPoint x between: x1 and: x2)
								and: [ (fromPoint y between: y1 and: y2)
										and: [ toPoint y between: y1 and: y2 ] ] ])
						ifTrue: [ aTwoArgumentBlock value: (edge atT: from) value: (edge atT: to) ] ] ]
]

{ #category : 'private' }
HGVoronoiDiagram >> purgeExtraEdges [
	regions do: [ :region | region purgeExtraEdges ]
]

{ #category : 'accessing' }
HGVoronoiDiagram >> regionThatContains: anHG2dPoint [
	| x y minSquaredDistance theRegion |
	x := anHG2dPoint x.
	y := anHG2dPoint y.
	minSquaredDistance := Float infinity.
	theRegion := nil.
	regions do: [:region | 
			| center squaredDistance dx dy |
			center := region center.
			squaredDistance := (dx := center x - x) * dx + ((dy := center y - y) * dy).
			squaredDistance < minSquaredDistance
				ifTrue: [ 
					minSquaredDistance := squaredDistance.
					theRegion := region ] ].
	^ theRegion
]

{ #category : 'enumerating' }
HGVoronoiDiagram >> regionsDo: aBlock [
	regions do: aBlock
]
