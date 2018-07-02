Class {
	#name : #HGKernel,
	#superclass : #Object,
	#category : 'HoneyGinger-Geometry-Neighbors'
}

{ #category : #copyrights }
HGKernel class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGKernel class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGKernel class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGKernel class >> support: aNumber [
	^ HGSimpleKernel new setSupport: aNumber
]

{ #category : #accessing }
HGKernel >> at: origin gradient: anHG2dPoint [
	^ self at: origin gradient: anHG2dPoint r: (origin distance: anHG2dPoint)
]

{ #category : #accessing }
HGKernel >> at: origin gradient: anHG2dPoint r: r [
	^ (HG2dPoint x: (anHG2dPoint x - origin x) / r y: anHG2dPoint y - origin y) mul: (self gradient: r)
]

{ #category : #accessing }
HGKernel >> at: origin value: anHG2dPoint [
	^ self at: origin value: anHG2dPoint r: (origin distance: anHG2dPoint)
]

{ #category : #accessing }
HGKernel >> at: origin value: anHG2dPoint r: r [
	^ self r: r
]

{ #category : #accessing }
HGKernel >> delta [
	^ 1.0e-3
]

{ #category : #accessing }
HGKernel >> gradient: r [
	^ ((self r: r + self delta) - (self r: r)) / self delta
]

{ #category : #accessing }
HGKernel >> r: aNumber [
	^ self subclassResponsibility 
]

{ #category : #accessing }
HGKernel >> support [
	^ self subclassResponsibility 
]
