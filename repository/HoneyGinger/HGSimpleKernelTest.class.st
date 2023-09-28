Class {
	#name : 'HGSimpleKernelTest',
	#superclass : 'TestCase',
	#instVars : [
		'kernel'
	],
	#category : 'HoneyGinger-Geometry-Tests',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Tests'
}

{ #category : 'copyrights' }
HGSimpleKernelTest class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGSimpleKernelTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGSimpleKernelTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'asserting' }
HGSimpleKernelTest >> assert: expected equals: actual accuracy: acceptableError [
	self assert: (expected - actual) abs <= acceptableError
]

{ #category : 'setup' }
HGSimpleKernelTest >> setUp [
	kernel := HGSimpleKernel support: 2.0
]

{ #category : 'tests' }
HGSimpleKernelTest >> testAtValue [
	0.0 to: 3.0 by: 1.0 do: [ :r | self assert: (kernel r: r) equals: (kernel at: (HG2dPoint theta: 1.0 r: 1.0) value: (HG2dPoint theta: 1.0 r: 1.0 + r)) accuracy: 1.0e-8 ]
]

{ #category : 'tests' }
HGSimpleKernelTest >> testGradient1 [
	self assert: 0.5 equals: (kernel gradient: 0.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testGradient2 [
	self assert: 0.5 equals: (kernel gradient: 1.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testGradient3 [
	self assert: 0.0 equals: (kernel gradient: 2.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testGradient4 [
	self assert: 0.0 equals: (kernel gradient: 3.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testR1 [
	self assert: 1.0 equals: (kernel r: 0.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testR2 [
	self assert: 0.5 equals: (kernel r: 1.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testR3 [
	self assert: 0.0 equals: (kernel r: 2.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HGSimpleKernelTest >> testR4 [
	self assert: 0.0 equals: (kernel r: 3.0) accuracy: 1.0e-8
]
