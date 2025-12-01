Class {
	#name : 'HGBorderlinePressureVisualizer',
	#superclass : 'HGAbstractBorderlinePressureVisualizer',
	#instVars : [
		'width',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'instance creation' }
HGBorderlinePressureVisualizer class >> pressure: pressure width: width color: aColor [
	^ self
		pressure: pressure
		xgrids: 40
		ygrids: 40
		kernel: (HGSimpleKernel support: 30)
		width: width
		color: aColor
]

{ #category : 'instance creation' }
HGBorderlinePressureVisualizer class >> pressure: pressure xgrids: xgrids ygrids: ygrids kernel: kernel width: width color: aColor [
	^ self new
		pressure: pressure;
		xgrids: xgrids;
		ygrids: ygrids;
		kernel: kernel;
		width: width;
		color: aColor;
		yourself
]

{ #category : 'accessing' }
HGBorderlinePressureVisualizer >> color [
	^ color
]

{ #category : 'accessing' }
HGBorderlinePressureVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'initialize-release' }
HGBorderlinePressureVisualizer >> initialize0001to0111 [
	marchingSquares
		at: 2r0001
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self top: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0010
		put: [ :args | 
			(args at: 9)
				line: (self right: args)
				to: (self top: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0011
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self right: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0100
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0101
		put: [ :args | 
			(args at: 9)
				line: (self top: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0110
		put: [ :args | 
			(args at: 9)
				line: (self top: args)
				to: (self left: args)
				width: width
				color: color.
			(args at: 9)
				line: (self right: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r0111
		put: [ :args | 
			(args at: 9)
				line: (self right: args)
				to: (self bottom: args)
				width: width
				color: color ]
]

{ #category : 'initialize-release' }
HGBorderlinePressureVisualizer >> initialize1000to1111 [
	marchingSquares
		at: 2r1000
		put: [ :args | 
			(args at: 9)
				line: (self right: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1001
		put: [ :args | 
			(args at: 9)
				line: (self top: args)
				to: (self right: args)
				width: width
				color: color.
			(args at: 9)
				line: (self left: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1010
		put: [ :args | 
			(args at: 9)
				line: (self top: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1011
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self bottom: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1100
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self right: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1101
		put: [ :args | 
			(args at: 9)
				line: (self top: args)
				to: (self right: args)
				width: width
				color: color ].
	marchingSquares
		at: 2r1110
		put: [ :args | 
			(args at: 9)
				line: (self left: args)
				to: (self top: args)
				width: width
				color: color ].
	marchingSquares at: 2r1111 put: [ :args |  ]
]

{ #category : 'accessing' }
HGBorderlinePressureVisualizer >> width [
	^ width
]

{ #category : 'accessing' }
HGBorderlinePressureVisualizer >> width: aNumber [
	width := aNumber
]
