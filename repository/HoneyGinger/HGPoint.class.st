Class {
	#name : 'HGPoint',
	#superclass : 'Object',
	#category : 'HoneyGinger-Geometry-Points',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Points'
}

{ #category : 'copyrights' }
HGPoint class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGPoint class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'utilities' }
HGPoint class >> areaFromVolume: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'instance creation' }
HGPoint class >> fromNumber: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'instance creation' }
HGPoint class >> fromPoint: aPoint [
	^ self subclassResponsibility 
]

{ #category : 'utilities' }
HGPoint class >> lengthFromVolume: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'instance creation' }
HGPoint class >> randomFrom: aHGPoint to: anotherHGPoint with: aRandom [
	^ self subclassResponsibility
]

{ #category : 'copyrights' }
HGPoint class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGPoint class >> zero [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> * aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> + anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> - anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> / aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> // aNumber [
	^ self subclassResponsibility 
]

{ #category : 'comparing' }
HGPoint >> < anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'comparing' }
HGPoint >> <= anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'comparing' }
HGPoint >> = anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'comparing' }
HGPoint >> > anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'comparing' }
HGPoint >> >= anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> abs [
	^ self norm1
]

{ #category : 'arithmetics' }
HGPoint >> add: anHGPoint by: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> add: aPoint minus: anotherPoint by: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> add: anHGPoint over: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> ceiling [
	^ self subclassResponsibility
]

{ #category : 'enumerating' }
HGPoint >> corner: anHGPoint do: aBlock [
	^ self subclassResponsibility 
]

{ #category : 'enumerating' }
HGPoint >> corner: anHGPoint elementsDo: aBlock [
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
HGPoint >> dimensions [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> distance: anHGPoint [
	^ (self - anHGPoint) norm2
]

{ #category : 'arithmetics' }
HGPoint >> dot: anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> floor [
	^ self subclassResponsibility
]

{ #category : 'comparing' }
HGPoint >> hash [
	^self subclassResponsibility 
]

{ #category : 'testing' }
HGPoint >> in: anHGPoint radius: aNumber [
	^ (self distance: anHGPoint) < aNumber
]

{ #category : 'accessing' }
HGPoint >> indexIn: anHGPoint [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> laplace: aBlock delta: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> length [
	^ self norm2
]

{ #category : 'vector' }
HGPoint >> length: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> min: anHGPoint max: anotherHGPoint [
	^ self subclassResponsibility
]

{ #category : 'vector' }
HGPoint >> norm1 [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> norm2 [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> norm: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> plus: anHGPoint by: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'arithmetics' }
HGPoint >> plus: anHGPoint over: aNumber [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> product [
	^ self subclassResponsibility 
]

{ #category : 'vector' }
HGPoint >> unit [
	| n |
	n := self norm2.
	^n < 1.0e-20 ifTrue: [self] ifFalse: [self / self norm2]
]
