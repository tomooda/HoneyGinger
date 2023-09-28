Class {
	#name : 'HGDynamicDotsVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'radiusBlock',
		'colorBlock'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGDynamicDotsVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGDynamicDotsVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGDynamicDotsVisualizer class >> radius: radiusBlock color: colorBlock [
	^ (self new)
		radiusBlock: radiusBlock;
		colorBlock: colorBlock;
		yourself
]

{ #category : 'accessing' }
HGDynamicDotsVisualizer >> colorBlock [
	^ colorBlock
]

{ #category : 'accessing' }
HGDynamicDotsVisualizer >> colorBlock: aBlock [
	colorBlock := aBlock
]

{ #category : 'drawing' }
HGDynamicDotsVisualizer >> draw: anHGSimulator on: aCanvas [
	anHGSimulator
		particlesDo: [ :particle | 
			| p |
			p := particle position.
			p
				ifNotNil: [ 
					| radius color |
					radius := radiusBlock value: anHGSimulator value: particle.
					color := colorBlock value: anHGSimulator value: particle.
					aCanvas fillOval: ((p x - radius) @ (p y - radius) extent: 2 @ 2 * radius) color: color ] ]
]

{ #category : 'accessing' }
HGDynamicDotsVisualizer >> radiusBlock [
	^ radiusBlock
]

{ #category : 'accessing' }
HGDynamicDotsVisualizer >> radiusBlock: aBlock [
	radiusBlock := aBlock
]
