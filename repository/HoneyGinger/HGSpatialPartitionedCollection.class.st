Class {
	#name : #HGSpatialPartitionedCollection,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'origin',
		'corner',
		'step',
		'size'
	],
	#category : 'HoneyGinger-Geometry-Neighbors'
}

{ #category : #copyrights }
HGSpatialPartitionedCollection class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGSpatialPartitionedCollection class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGSpatialPartitionedCollection class >> origin: anHGPoint corner: anotherHGPoint step: aNumber [
	| size |
	size := ((anotherHGPoint - anHGPoint) / aNumber) floor + (anHGPoint class fromNumber: 1).
	^ (self new: size product)
		setOrigin: anHGPoint
		corner: anotherHGPoint
		step: aNumber
		size: size
]

{ #category : #copyrights }
HGSpatialPartitionedCollection class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> at: anHGPoint add: anObject [
	^ ((self indexAt: anHGPoint) ifNotNilDo: [ :index | (self at: index) add: anObject ])
]

{ #category : #enumerating }
HGSpatialPartitionedCollection >> at: anHGPoint do: aBlock [
	^((self indexAt: anHGPoint) ifNotNilDo: [ :index | (self at: index) do: aBlock ])
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> at: anHGPoint remove: anObject [
	^ self at: ((self indexAt: anHGPoint) ifNotNilDo: [ :partition | partition remove: anObject ])
]

{ #category : #enumerating }
HGSpatialPartitionedCollection >> at: anHGPoint within: aNumber do: aBlock [
	| from to |
	from := anHGPoint - (anHGPoint class fromNumber: aNumber).
	to := anHGPoint + (anHGPoint class fromNumber: aNumber).
	self from: from to: to do: aBlock
]

{ #category : #enumerating }
HGSpatialPartitionedCollection >> do: aBlock [
	1 to: self size do: [ :index | (self at: index) do: aBlock ]
]

{ #category : #enumerating }
HGSpatialPartitionedCollection >> from: anHGPoint to: anotherHGPoint do: aBlock [
	(self indexPointAt: anHGPoint)
		corner: (self indexPointAt: anotherHGPoint)
		do: [ :indexPoint | 
			| index |
			index := indexPoint indexIn: size.
			index ifNotNil: [ (self at: index) do: aBlock ] ]
]

{ #category : #enumerating }
HGSpatialPartitionedCollection >> from: anHGPoint to: anotherHGPoint partitionsDo: aBlock [
	(self indexPointAt: anHGPoint)
		corner: (self indexPointAt: anotherHGPoint)
		do: [ :indexPoint | 
			| index |
			index := indexPoint indexIn: size.
			index ifNotNil: [ aBlock value: (self at: index) ] ]
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> indexAt: anHGPoint [
	^ (self indexPointAt: anHGPoint) indexIn: size
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> indexPointAt: anHGPoint [
	^ ((anHGPoint - origin) / step) floor
]

{ #category : #'initialize-release' }
HGSpatialPartitionedCollection >> initialize [
	1 to: self size do: [ :index | self at: index put: IdentitySet new]
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> move: anObject from: anHGPoint to: anotherHGPoint [
	| from to |
	from := self indexAt: anHGPoint.
	to := self indexAt: anotherHGPoint.
	from = to
		ifFalse: [ 
			(self at: from) remove: anObject.
			(self at: to) add: anObject ].
	^ anObject
]

{ #category : #private }
HGSpatialPartitionedCollection >> setOrigin: anHGPoint corner: anotherHGPoint step: aNumber size: sizePoint [
	origin := anHGPoint.
	corner := anotherHGPoint.
	step := aNumber.
	size := sizePoint
]

{ #category : #accessing }
HGSpatialPartitionedCollection >> sizePoint [
	^size
]
