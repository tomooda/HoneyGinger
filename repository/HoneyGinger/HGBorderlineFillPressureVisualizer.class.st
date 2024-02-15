Class {
	#name : 'HGBorderlineFillPressureVisualizer',
	#superclass : 'HGAbstractBorderlinePressureVisualizer',
	#instVars : [
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGBorderlineFillPressureVisualizer class >> pressure: pressure color: aColor [
	^ self
		pressure: pressure
		xgrids: 40
		ygrids: 40
		kernel: (HGSimpleKernel support: 30)
		color: aColor
]

{ #category : 'instance creation' }
HGBorderlineFillPressureVisualizer class >> pressure: pressure xgrids: xgrids ygrids: ygrids kernel: kernel color: aColor [
	^ self new
		pressure: pressure;
		xgrids: xgrids;
		ygrids: ygrids;
		kernel: kernel;
		color: aColor;
		yourself
]

{ #category : 'accessing' }
HGBorderlineFillPressureVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGBorderlineFillPressureVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'initialize-release' }
HGBorderlineFillPressureVisualizer >> initialize0001to0111 [
	marchingSquares
		at: 2r0001
		put: [ :args | 
			(args at: 9)
				drawPolygon: (Array with: (self leftTop: args) with: (self top: args) with: (self left: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0010
		put: [ :args | 
			(args at: 9)
				drawPolygon: (Array with: (self rightTop: args) with: (self right: args) with: (self top: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0011
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self rightTop: args)
						with: (self right: args)
						with: (self left: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0100
		put: [ :args | 
			(args at: 9)
				drawPolygon: (Array with: (self leftBottom: args) with: (self left: args) with: (self bottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0101
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self top: args)
						with: (self bottom: args)
						with: (self leftBottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0110
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self rightTop: args)
						with: (self right: args)
						with: (self bottom: args)
						with: (self leftBottom: args)
						with: (self left: args)
						with: (self top: args))
				fillStyle: color ].
	marchingSquares
		at: 2r0111
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self rightTop: args)
						with: (self right: args)
						with: (self bottom: args)
						with: (self leftBottom: args))
				fillStyle: color ]
]

{ #category : 'initialize-release' }
HGBorderlineFillPressureVisualizer >> initialize1000to1111 [
	marchingSquares
		at: 2r1000
		put: [ :args | 
			(args at: 9)
				drawPolygon: (Array with: (self right: args) with: (self rightBottom: args) with: (self bottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1001
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self top: args)
						with: (self right: args)
						with: (self rightBottom: args)
						with: (self bottom: args)
						with: (self left: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1010
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self top: args)
						with: (self rightTop: args)
						with: (self rightBottom: args)
						with: (self bottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1011
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self rightTop: args)
						with: (self rightBottom: args)
						with: (self bottom: args)
						with: (self left: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1100
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self left: args)
						with: (self right: args)
						with: (self rightBottom: args)
						with: (self leftBottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1101
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self leftTop: args)
						with: (self top: args)
						with: (self right: args)
						with: (self rightBottom: args)
						with: (self leftBottom: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1110
		put: [ :args | 
			(args at: 9)
				drawPolygon:
					(Array
						with: (self top: args)
						with: (self rightTop: args)
						with: (self rightBottom: args)
						with: (self leftBottom: args)
						with: (self left: args))
				fillStyle: color ].
	marchingSquares
		at: 2r1111
		put: [ :args | (args at: 9) fillRectangle: ((self leftTop: args) corner: (self rightBottom: args)) color: color ]
]
