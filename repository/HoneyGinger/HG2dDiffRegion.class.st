Class {
	#name : #HG2dDiffRegion,
	#superclass : #HG2dRegion,
	#instVars : [
		'positive',
		'negative'
	],
	#category : 'HoneyGinger-Geometry-Regions'
}

{ #category : #copyrights }
HG2dDiffRegion class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HG2dDiffRegion class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HG2dDiffRegion class >> within: anHG2dRegion except: anotherHG2dRegion [
	^ (self new)
		setPositive: anHG2dRegion negative: anotherHG2dRegion;
		yourself
]

{ #category : #testing }
HG2dDiffRegion >> contains: anHG2dPoint [
	^ (positive contains: anHG2dPoint) and: [ (negative contains: anHG2dPoint) not ]
]

{ #category : #private }
HG2dDiffRegion >> setPositive: anHG2dRegion negative: anotherHG2dRegion [
	positive := anHG2dRegion.
	negative := anotherHG2dRegion
]
