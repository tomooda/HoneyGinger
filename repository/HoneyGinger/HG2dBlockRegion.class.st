Class {
	#name : 'HG2dBlockRegion',
	#superclass : 'HG2dRegion',
	#instVars : [
		'block'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'copyrights' }
HG2dBlockRegion class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dBlockRegion class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HG2dBlockRegion class >> on: aBlock [
	^ (self new)
		block: aBlock;
		yourself
]

{ #category : 'accessing' }
HG2dBlockRegion >> block [
	^ block
]

{ #category : 'accessing' }
HG2dBlockRegion >> block: aBlock [
	block := aBlock
]

{ #category : 'accessing' }
HG2dBlockRegion >> borderAt: anHG2dPoint [
	| delta |
	delta := 1.
	[ 
	delta negated to: delta do: [ :dx | 
		| p |
		p := anHG2dPoint + (HG2dPoint x: dx y: delta).
		(self contains: p)
			ifFalse: [ ^ p ].
		p := anHG2dPoint + (HG2dPoint x: dx y: delta negated).
		(self contains: p)
			ifFalse: [ ^ p ] ].
	delta negated to: delta do: [ :dy | 
		| p |
		p := anHG2dPoint + (HG2dPoint x: delta y: dy).
		(self contains: p)
			ifFalse: [ ^ p ].
		p := anHG2dPoint + (HG2dPoint x: delta negated y: dy).
		(self contains: p)
			ifFalse: [ ^ p ] ].
	delta := delta + 1 ] repeat
]

{ #category : 'testing' }
HG2dBlockRegion >> contains: anHG2dPoint [
	^ block value: anHG2dPoint
]

{ #category : 'drawing' }
HG2dBlockRegion >> drawOn: aCanvas color: aColor [
]
