Class {
	#name : 'HGParticlesVelocityVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'radius',
		'width',
		'scale',
		'color'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGParticlesVelocityVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGParticlesVelocityVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGParticlesVelocityVisualizer class >> radius: radius width: width scale: scale color: color [
	^ (self new)
		radius: radius;
		width: width;
		scale: scale;
		color: color;
		yourself
]

{ #category : 'copyrights' }
HGParticlesVelocityVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> color [
	^color
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGParticlesVelocityVisualizer >> draw: anHGSimulator on: aCanvas [
	anHGSimulator
		particlesDo: [ :particle | 
			| p v form |
			p := particle position.
			v := particle velocity.
			p
				ifNotNil: [ 
					aCanvas fillOval: ((p x - radius) @ (p y - radius) extent: 2 @ 2 * radius) color: color.
					v
						ifNotNil: [ 
							aCanvas
								line: p x @ p y
								to: (v x * scale + p x) @ (v y * scale + p y)
								width: width
								color: color ] ] ]
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> radius [
	^radius
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> radius: aNumber [
	radius := aNumber
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> scale [
	^scale
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> scale: aNumber [
	scale := aNumber
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> width [
	^ width
]

{ #category : 'accessing' }
HGParticlesVelocityVisualizer >> width: aNumber [
	width := aNumber
]
