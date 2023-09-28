Class {
	#name : 'HGAbstractBorderlinePressureVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'pressure',
		'kernel',
		'xgrids',
		'ygrids',
		'marchingSquares'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> bottom: args [
	| leftBottomValue left |
	leftBottomValue := (args at: 3) abs asFloat.
	left := args at: 5.
	^ (leftBottomValue / (leftBottomValue + (args at: 4) abs) * ((args at: 6) - left) + left) @ (args at: 8)
]

{ #category : 'drawing' }
HGAbstractBorderlinePressureVisualizer >> draw: anHGSimulator on: aCanvas [
	| simulationOrigin simulationCorner pressureArrayBlock upperPressures xstep ystep args |
	simulationOrigin := anHGSimulator simulationOrigin.
	simulationCorner := anHGSimulator simulationCorner.
	xstep := (simulationCorner x - simulationOrigin x) / (xgrids-1) asFloat.
	ystep := (simulationCorner y - simulationOrigin y) / (ygrids-1) asFloat.
	pressureArrayBlock := [ :yIndex | 
	| y |
	y := ystep / 2.0 + (ystep * yIndex) + simulationOrigin y.
	(0 to: xgrids - 1)
		collect: [ :xIndex | 
			| x p denominator |
			x := xstep / 2.0 + (xstep * xIndex) + simulationOrigin x.
			p := 0.0.
			denominator := 0.0.
			anHGSimulator
				neighborsOf: (HG2dPoint x: x y: y)
				within: kernel support
				do: [ :neighbor :distance | 
					| r |
					r := kernel r: distance.
					p := neighbor pressure * r + p.
					denominator := denominator + r ].
			(denominator > 0.0
				ifTrue: [ p / denominator ]
				ifFalse: [ p ]) - pressure ] ].
	args := Array new: 9.
	args at: 9 put: aCanvas.
	upperPressures := pressureArrayBlock value: 0.
	1 to: ygrids - 1 do: [ :yIndex | 
		| lowerPressures y |
		lowerPressures := pressureArrayBlock value: yIndex.
		y := ystep * (yIndex - 1) + simulationOrigin y.
		1 to: xgrids - 1 do: [ :xIndex | 
			| leftTop rightTop leftBottom rightBottom squareIndex |
			leftTop := upperPressures at: xIndex.
			rightTop := upperPressures at: xIndex + 1.
			leftBottom := lowerPressures at: xIndex.
			rightBottom := lowerPressures at: xIndex + 1.
			squareIndex := self
				indexFor: leftTop
				and: rightTop
				and: leftBottom
				and: rightBottom.
			squareIndex > 0
				ifTrue: [ 
					| x |
					x := xstep * (xIndex - 1) + simulationOrigin x.
					args at: 1 put: leftTop.
					args at: 2 put: rightTop.
					args at: 3 put: leftBottom.
					args at: 4 put: rightBottom.
					args at: 5 put: x rounded.
					args at: 6 put: (x + xstep) rounded.
					args at: 7 put: y rounded.
					args at: 8 put: (y + ystep) rounded.
					(marchingSquares at: squareIndex) value: args ] ].
		upperPressures := lowerPressures ]
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> indexFor: leftTop and: rightTop and: leftBottom and: rightBottom [
	^ (leftTop > 0.0
		ifTrue: [ 1 ]
		ifFalse: [ 0 ])
		+
			(rightTop > 0.0
				ifTrue: [ 2 ]
				ifFalse: [ 0 ])
		+
			(leftBottom > 0.0
				ifTrue: [ 4 ]
				ifFalse: [ 0 ])
		+
			(rightBottom > 0.0
				ifTrue: [ 8 ]
				ifFalse: [ 0 ])
]

{ #category : 'initialize-release' }
HGAbstractBorderlinePressureVisualizer >> initialize [
	super initialize.
	marchingSquares := Array new: 2r1111.
	self initialize0001to0111.
	self initialize1000to1111
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> kernel [
	^ kernel
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> kernel: anHGKernel [
	kernel := anHGKernel
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> left: args [
	| leftTopValue top |
	leftTopValue := (args at: 1) abs asFloat.
	top := args at: 7.
	^ (args at: 5) @ (leftTopValue / (leftTopValue + (args at: 3) abs) * ((args at: 8) - top) + top)
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> leftBottom: args [
	^ (args at: 5) @ (args at: 8)
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> leftTop: args [
	^ (args at: 5) @ (args at: 7)
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> pressure [
	^ pressure
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> pressure: aNumber [
	pressure := aNumber
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> right: args [
	| rightTopValue top |
	rightTopValue := (args at: 2) abs asFloat.
	top := args at: 7.
	^ (args at: 6) @ (rightTopValue / (rightTopValue + (args at: 4) abs) * ((args at: 8) - top) + top)
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> rightBottom: args [
	^ (args at: 6) @ (args at: 8)
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> rightTop: args [
	^ (args at: 6) @ (args at: 7)
]

{ #category : 'private' }
HGAbstractBorderlinePressureVisualizer >> top: args [
	| leftTopValue left |
	leftTopValue := (args at: 1) abs asFloat.
	left := args at: 5.
	^ (leftTopValue / (leftTopValue + (args at: 2) abs) * ((args at: 6) - left) + left) @ (args at: 7)
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> xgrids [
	^ xgrids
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> xgrids: aNumber [
	xgrids := aNumber
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> ygrids [
	^ ygrids
]

{ #category : 'accessing' }
HGAbstractBorderlinePressureVisualizer >> ygrids: aNumber [
	ygrids := aNumber
]
