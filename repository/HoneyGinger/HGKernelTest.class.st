Class {
	#name : #HGKernelTest,
	#superclass : #HGTestCase,
	#instVars : [
		'kernel'
	],
	#category : 'HoneyGinger-Geometry-Tests'
}

{ #category : #copyrights }
HGKernelTest class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGKernelTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGKernelTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #setup }
HGKernelTest >> setUp [
	kernel := self targetClass support: 2.0
]

{ #category : #testing }
HGKernelTest >> shouldPass [
	^ false
]

{ #category : #private }
HGKernelTest >> targetClass [
	^ self subclassResponsibility 
]

{ #category : #tests }
HGKernelTest >> testAtGradient [
	0.0 to: 3.0 by: 1.0 do: [ :r | 
		self
			assert: (kernel gradient: r)
			equals: (kernel at: (HG2dPoint theta: 1.0 r: 1.0) gradient: (HG2dPoint theta: 1.0 r: 1.0 + r)) r ]
]

{ #category : #tests }
HGKernelTest >> testAtValue [
	0.0 to: 3.0 by: 1.0 do: [ :r | self assert: (kernel r: r) equals: (kernel at: (HG2dPoint theta: 1.0 r: 1.0) value: (HG2dPoint theta: 1.0 r: 1.0 + r)) ]
]
