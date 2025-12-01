Class {
	#name : 'HG2dUnionRegion',
	#superclass : 'HG2dRegion',
	#instVars : [
		'regions'
	],
	#category : 'HoneyGinger-Geometry-Regions',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Regions'
}

{ #category : 'copyrights' }
HG2dUnionRegion class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dUnionRegion class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HG2dUnionRegion class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HG2dUnionRegion class >> with: anHG2dRegion [
	^ self new add: anHG2dRegion ; yourself
]

{ #category : 'instance creation' }
HG2dUnionRegion class >> with: anHG2dRegion with: anotherHG2dRegion [
	^ (self new)
		add: anHG2dRegion;
		add: anotherHG2dRegion;
		yourself
]

{ #category : 'instance creation' }
HG2dUnionRegion class >> with: anHG2dRegion with: anotherHG2dRegion with: yetAnotherHG2dRegion [
	^ (self new)
		add: anHG2dRegion;
		add: anotherHG2dRegion;
		add: yetAnotherHG2dRegion;
		yourself
]

{ #category : 'instance creation' }
HG2dUnionRegion class >> with: anHG2dRegion with: anotherHG2dRegion with: yetAnotherHG2dRegion with: yetYetAnotherHG2dRegion [
	^ (self new)
		add: anHG2dRegion;
		add: anotherHG2dRegion;
		add: yetAnotherHG2dRegion;
		add: yetYetAnotherHG2dRegion;
		yourself
]

{ #category : 'instance creation' }
HG2dUnionRegion class >> withAll: aCollectionOfHG2dRegion [
	^ (self new)
		addAll: aCollectionOfHG2dRegion;
		yourself
]

{ #category : 'adding' }
HG2dUnionRegion >> add: anHG2dRegion [
	^ regions add: anHG2dRegion 
]

{ #category : 'adding' }
HG2dUnionRegion >> addAll: aCollectionOfHG2dRegion [
	^ regions addAll: aCollectionOfHG2dRegion 
]

{ #category : 'testing' }
HG2dUnionRegion >> conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint [
	^ regions anySatisfy: [ :region | region conflictsWithLineSegment: anHG2dPoint to: anotherHG2dPoint ]
]

{ #category : 'testing' }
HG2dUnionRegion >> contains: anHG2dPoint [
	^ regions anySatisfy: [ :region | region contains: anHG2dPoint ]
]

{ #category : 'initialize-release' }
HG2dUnionRegion >> initialize [
	super initialize.
	regions := OrderedCollection new
]
