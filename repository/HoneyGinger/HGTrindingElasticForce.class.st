Class {
	#name : 'HGTrindingElasticForce',
	#superclass : 'HGElasticForce',
	#instVars : [
		'color',
		'trindings'
	],
	#category : 'HoneyGinger-Actions-Elasticity',
	#package : 'HoneyGinger',
	#tag : 'Actions-Elasticity'
}

{ #category : 'copyrights' }
HGTrindingElasticForce class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGTrindingElasticForce class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGTrindingElasticForce class >> color: aColor [
	^ (self new)
		color: aColor;
		yourself
]

{ #category : 'copyrights' }
HGTrindingElasticForce class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'adding' }
HGTrindingElasticForce >> addTrindingAmong: anHGParticle1 and: anHGParticle2 and: anHGParticle3 [
	^ trindings add: (HGTrinding among: anHGParticle1 and: anHGParticle2 and: anHGParticle3)
]

{ #category : 'simulating' }
HGTrindingElasticForce >> breakTrindingsAround: anHG2dPoint within: aNumber [
	trindings
		removeAllSuchThat: [ :trinding | ((trinding borderAt: anHG2dPoint) distance: anHG2dPoint ) < aNumber]
]

{ #category : 'accessing' }
HGTrindingElasticForce >> color [
	^ color
]

{ #category : 'accessing' }
HGTrindingElasticForce >> color: aColor [
	color := aColor
]

{ #category : 'drawing' }
HGTrindingElasticForce >> draw: anHGSimulator on: aCanvas [
	trindings
		do: [ :trinding | 
			aCanvas
				drawPolygon:
					(Array
						with: trinding particle1 position asPoint
						with: trinding particle2 position asPoint
						with: trinding particle3 position asPoint)
				fillStyle: (color).
			aCanvas
				line: trinding particle1 position asPoint
				to: trinding particle2 position asPoint
				width: 1
				color: color.
			aCanvas
				line: trinding particle2 position asPoint
				to: trinding particle3 position asPoint
				width: 1
				color: color.
			aCanvas
				line: trinding particle3 position asPoint
				to: trinding particle1 position asPoint
				width: 1
				color: color ]
]

{ #category : 'drawing' }
HGTrindingElasticForce >> draw: anHGSimulator outlines: aCollectionOfArrayOfVerticePairs on: aCanvas [
	trindings
		do: [ :trinding | 
			aCanvas
				drawPolygon:
					(Array
						with: trinding particle1 position asPoint
						with: trinding particle2 position asPoint
						with: trinding particle3 position asPoint)
				fillStyle: (color mixed: 0.6 with: anHGSimulator color) ].
	aCollectionOfArrayOfVerticePairs
		do: [ :outline | 
			outline
				do: [ :pair | 
					aCanvas
						line: (pair at: 1) position asPoint
						to: (pair at: 2) position asPoint
						width: 3
						color: color ] ]
]

{ #category : 'simulating' }
HGTrindingElasticForce >> effectIn: anHGSimulator deltaT: aNumber [
	| distanceBlock outlines |
	trindings removeAllSuchThat: [ :trinding | trinding area < 0.0 ].
	self effectShapesIn: anHGSimulator deltaT: aNumber.
	outlines := OrderedCollection new.
	(HGElasticBody isolatedBodiesWithAll: trindings)
		do: [ :body | 
			| outline |
			outline := Array new writeStream.
			body pairsDo: [ :vertex1 :vertex2 | outline nextPut: (Array with: vertex1 with: vertex2)].
			outlines add: outline contents.
			anHGSimulator particlesDo: [ :particle | body bump: particle ] ].
	self color ifNotNil: [ self draw: anHGSimulator outlines: outlines on: anHGSimulator form getCanvas ]
]

{ #category : 'simulating' }
HGTrindingElasticForce >> effectShapesIn: anHGSimulator deltaT: aNumber [.
	^ self subclassResponsibility 
]

{ #category : 'initialize-release' }
HGTrindingElasticForce >> initialize [
	super initialize.
	trindings := OrderedCollection new: 100.
]
