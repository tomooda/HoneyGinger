Class {
	#name : #HGSolenthalerKernel,
	#superclass : #HGKernel,
	#instVars : [
		'h',
		'c',
		'halfPi',
		'support',
		'halfPiOverH',
		'cOverHalfPiOverH'
	],
	#category : 'HoneyGinger-Geometry-Neighbors'
}

{ #category : #copyrights }
HGSolenthalerKernel class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGSolenthalerKernel class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGSolenthalerKernel class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGSolenthalerKernel class >> support: aNumber [
	^ self new setH: aNumber
]

{ #category : #accessing }
HGSolenthalerKernel >> gradient: aNumber [
	| r |
	r := aNumber abs.
	r >= h
		ifTrue: [ ^ 0 ].
	^ ((r + h) * halfPiOverH) sin negated * c
]

{ #category : #accessing }
HGSolenthalerKernel >> r: aNumber [
	| r |
	r := aNumber abs.
	r >= h
		ifTrue: [ ^ 0 ].
	^ cOverHalfPiOverH * ((r + h) * halfPiOverH) cos + cOverHalfPiOverH
]

{ #category : #private }
HGSolenthalerKernel >> setH: aNumber [
	| pi |
	pi := Float pi.
	h := aNumber.
	c := pi / 8.0 / h / h / h / h / (pi / 3.0 - (8.0 / pi) + (16.0 / pi / pi)).
	halfPi := pi / 2.0.
	halfPiOverH := halfPi / h.
	cOverHalfPiOverH := c / halfPiOverH
]

{ #category : #accessing }
HGSolenthalerKernel >> support [
	^ h
]
