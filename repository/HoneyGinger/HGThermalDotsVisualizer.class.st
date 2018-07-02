Class {
	#name : #HGThermalDotsVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'radius',
		'blueTemperature',
		'redTemperature'
	],
	#category : 'HoneyGinger-Actions-UI'
}

{ #category : #copyrights }
HGThermalDotsVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGThermalDotsVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGThermalDotsVisualizer class >> radius: radiusOfDot blueTemperature: minTemperature redTemperature: maxTemperature [
	^ (self new)
		radius: radiusOfDot;
		blueTemperature: minTemperature;
		redTemperature: maxTemperature;
		yourself
]

{ #category : #copyrights }
HGThermalDotsVisualizer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGThermalDotsVisualizer >> blueTemperature [ 
	^ blueTemperature 
]

{ #category : #accessing }
HGThermalDotsVisualizer >> blueTemperature: aNumber [
	blueTemperature := aNumber
]

{ #category : #drawing }
HGThermalDotsVisualizer >> draw: anHGSimulator on: aCanvas [
	| rate |
	rate := 240.0 / (redTemperature - blueTemperature).
	anHGSimulator
		particlesDo: [ :particle | 
			| p color |
			p := particle position.
			color := Color
				h: (redTemperature - (particle temperature min: redTemperature max: blueTemperature)) * rate
				s: 1.0
				v: 1.0.
			p ifNotNil: [ aCanvas fillOval: ((p x - radius) @ (p y - radius) extent: 2 @ 2 * radius) color: color ] ]
]

{ #category : #accessing }
HGThermalDotsVisualizer >> radius [
	^ radius
]

{ #category : #accessing }
HGThermalDotsVisualizer >> radius: aNumber [
	radius := aNumber
]

{ #category : #accessing }
HGThermalDotsVisualizer >> redTemperature [ 
	^ redTemperature 
]

{ #category : #accessing }
HGThermalDotsVisualizer >> redTemperature: aNumber [
	redTemperature := aNumber
]
