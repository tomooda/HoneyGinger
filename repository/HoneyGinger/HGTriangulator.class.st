Class {
	#name : #HGTriangulator,
	#superclass : #Object,
	#instVars : [
		'triangles'
	],
	#category : 'HoneyGinger-Geometry-Neighbors'
}

{ #category : #copyrights }
HGTriangulator class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGTriangulator class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HGTriangulator class >> origin: anHGPoint corner: anotherHGPoint step: aNumber [
	^ self new setOrigin: anHGPoint corner: anotherHGPoint step: aNumber
]

{ #category : #copyrights }
HGTriangulator class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #operations }
HGTriangulator >> divideAt: anHG2dPoint [
	| triangle from to triangle1 from1 to1 triangle2 from2 to2 triangle3 from3 to3 pair1 va1 pair2 va2 pair3 va3 agenda |
	triangle := self triangleAt: anHG2dPoint.
	triangle ifNil: [ ^ nil ].
	triangle1 := HG2dTriangle on: triangle vertex1 on: triangle vertex2 on: anHG2dPoint.
	triangle2 := HG2dTriangle on: triangle vertex2 on: triangle vertex3 on: anHG2dPoint.
	triangle3 := HG2dTriangle on: triangle vertex3 on: triangle vertex1 on: anHG2dPoint.
	self
		neighborPairParams: triangle
		do: [ :params :pairParams | 
			(pairParams at: 5) == triangle vertex3
				ifTrue: [ 
					pairParams at: 1 put: triangle1.
					pairParams at: 5 put: anHG2dPoint.
					pair1 := params at: 1.
					va1 := params at: 5 ]
				ifFalse: [ 
					(pairParams at: 5) == triangle vertex1
						ifTrue: [ 
							pairParams at: 1 put: triangle2.
							pairParams at: 5 put: anHG2dPoint.
							pair2 := params at: 1.
							va2 := params at: 5 ]
						ifFalse: [ 
							(pairParams at: 5) == triangle vertex2
								ifTrue: [ 
									pairParams at: 1 put: triangle3.
									pairParams at: 5 put: anHG2dPoint.
									pair3 := params at: 1.
									va3 := params at: 5 ] ] ] ].
	triangles removeKey: triangle.
	triangles
		at: triangle1
		put:
			(OrderedCollection
				with:
					(Array
						with: triangle2
						with: triangle vertex2
						with: anHG2dPoint
						with: triangle vertex1
						with: triangle vertex3)
				with:
					(Array
						with: triangle3
						with: anHG2dPoint
						with: triangle vertex1
						with: triangle vertex2
						with: triangle vertex3)).
	pair1
		ifNotNil: [ 
			(triangles at: triangle1)
				add:
					(Array
						with: pair1
						with: triangle vertex1
						with: triangle vertex2
						with: anHG2dPoint
						with: va1) ].
	triangles
		at: triangle2
		put:
			(OrderedCollection
				with:
					(Array
						with: triangle3
						with: triangle vertex3
						with: anHG2dPoint
						with: triangle vertex2
						with: triangle vertex1)
				with:
					(Array
						with: triangle1
						with: anHG2dPoint
						with: triangle vertex2
						with: triangle vertex3
						with: triangle vertex1)).
	pair2
		ifNotNil: [ 
			(triangles at: triangle2)
				add:
					(Array
						with: pair2
						with: triangle vertex2
						with: triangle vertex3
						with: anHG2dPoint
						with: va2) ].
	triangles
		at: triangle3
		put:
			(OrderedCollection
				with:
					(Array
						with: triangle1
						with: triangle vertex1
						with: anHG2dPoint
						with: triangle vertex3
						with: triangle vertex2)
				with:
					(Array
						with: triangle2
						with: anHG2dPoint
						with: triangle vertex3
						with: triangle vertex1
						with: triangle vertex2)).
	pair3
		ifNotNil: [ 
			(triangles at: triangle3)
				add:
					(Array
						with: pair3
						with: triangle vertex3
						with: triangle vertex1
						with: anHG2dPoint
						with: va3) ].
	agenda := IdentitySet new: 4.
	agenda add: triangle1.
	agenda add: triangle2.
	agenda add: triangle3.
	self optimize: agenda
]

{ #category : #private }
HGTriangulator >> flip: triangle1 with: neighborParams agenda: agenda [
	| triangle2 v1 v2 va vb triangleA triangleB |
	triangle2 := neighborParams at: 1.
	v1 := neighborParams at: 2.
	v2 := neighborParams at: 3.
	va := neighborParams at: 4.
	vb := neighborParams at: 5.
	triangleA := HG2dTriangle on: v1 on: vb on: va.
	triangleB := HG2dTriangle on: v2 on: va on: vb.
	triangles
		at: triangleA
		put:
			(OrderedCollection
				with:
					(Array
						with: triangleB
						with: vb
						with: va
						with: v1
						with: v2)).
	triangles
		at: triangleB
		put:
			(OrderedCollection
				with:
					(Array
						with: triangleA
						with: va
						with: vb
						with: v2
						with: v1)).
	self
		neighborPairParams: triangle1
		do: [ :params1 :paramsX | 
			(paramsX at: 5) == v1
				ifTrue: [ 
					paramsX at: 1 put: triangleB.
					paramsX at: 5 put: vb.
					(triangles at: triangleB)
						add:
							(Array
								with: (params1 at: 1)
								with: v2
								with: va
								with: vb
								with: (params1 at: 5)) ].
			(paramsX at: 5) == v2
				ifTrue: [ 
					paramsX at: 1 put: triangleA.
					paramsX at: 5 put: vb.
					(triangles at: triangleA)
						add:
							(Array
								with: (params1 at: 1)
								with: va
								with: v1
								with: vb
								with: (params1 at: 5)) ] ].
	self
		neighborPairParams: triangle2
		do: [ :params2 :paramsX | 
			(paramsX at: 5) == v1
				ifTrue: [ 
					paramsX at: 1 put: triangleB.
					paramsX at: 5 put: va.
					(triangles at: triangleB)
						add:
							(Array
								with: (params2 at: 1)
								with: vb
								with: v2
								with: va
								with: (params2 at: 5)) ].
			(paramsX at: 5) == v2
				ifTrue: [ 
					paramsX at: 1 put: triangleA.
					paramsX at: 5 put: va.
					(triangles at: triangleA)
						add:
							(Array
								with: (params2 at: 1)
								with: v1
								with: vb
								with: va
								with: (params2 at: 5)) ] ].
	triangles removeKey: triangle1 ifAbsent: [].
	triangles removeKey: triangle2 ifAbsent: [].
	agenda
		ifNotNil: [ 
			agenda remove: triangle2 ifAbsent: [].
			agenda add: triangleA.
			agenda add: triangleB ]
]

{ #category : #private }
HGTriangulator >> minAngleOn: vertex1 on: vertex2 on: vertex3 [
	| area d l12 l23 l31 angle1 angle2 angle3 |
	area := vertex1 to: vertex2 cross: vertex3.
	l12 := (d := vertex1 x - vertex2 x) * d + ((d := vertex1 y - vertex2 y) * d).
	l23 := (d := vertex2 x - vertex3 x) * d + ((d := vertex2 y - vertex3 y) * d).
	l31 := (d := vertex3 x - vertex1 x) * d + ((d := vertex3 y - vertex1 y) * d).
	^l12 < l23
		ifTrue: [ 
			l12 < l31
				ifTrue: [ area / (l23 * l31) sqrt ]
				ifFalse: [ area /( l12 * l23) sqrt ] ]
		ifFalse: [ 
			l23 < l31
				ifTrue: [ area / (l12 * l31) sqrt ]
				ifFalse: [ area / (l12 * l23) sqrt ] ]
]

{ #category : #private }
HGTriangulator >> neighborPairParams: anHG2dTriangle do: aBlock [
	(triangles at: anHG2dTriangle)
		do: [ :params | 
			(triangles at: (params at: 1) ifAbsent: [#()])
				do: [ :pairParams | 
					(pairParams at: 1) == anHG2dTriangle
						ifTrue: [ aBlock value: params value: pairParams ] ] ]
]

{ #category : #operations }
HGTriangulator >> optimize [
	| agenda |
	agenda := IdentitySet new: triangles size.
	self trianglesDo: [ :triangle | agenda add: triangle].
	self optimize: agenda
]

{ #category : #operations }
HGTriangulator >> optimize: anIdentitySet [
	[ anIdentitySet isEmpty ]
		whileFalse: [ 
			| triangle |
			triangle := anIdentitySet anyOne.
			anIdentitySet remove: triangle ifAbsent: [].
			self optimize: anIdentitySet triangle: triangle ]
]

{ #category : #operations }
HGTriangulator >> optimize: anIdentitySet triangle: anHG2dTriangle [
	| minAngle1 |
	minAngle1 := self minAngleOn: anHG2dTriangle vertex1 on: anHG2dTriangle vertex2 on: anHG2dTriangle vertex3.
	(triangles at: anHG2dTriangle)
		do: [ :params | 
			| v1 v2 va vb |
			v1 := params at: 2.
			v2 := params at: 3.
			va := params at: 4.
			vb := params at: 5.
			((vb to: va cross: v1) > 0.0
				and: [ 
					(va to: vb cross: v2) > 0.0
						and: [ 
							(minAngle1 min: (self minAngleOn: vb on: v2 on: v1))
								< ((self minAngleOn: v1 on: vb on: va) min: (self minAngleOn: v2 on: va on: vb)) ] ])
				ifTrue: [ ^ self flip: anHG2dTriangle with: params agenda: anIdentitySet ] ]
]

{ #category : #private }
HGTriangulator >> sanityCheck [
	triangles
		keysAndValuesDo: [ :triangle :paramsList | 
			paramsList
				do: [ :params | 
					| pairParams |
					pairParams := (triangles at: (params at: 1))
						detect: [ :p | p first == triangle ]
						ifNone: [ self error: 'triangle not found in its neighbor''s neighbors list' ].
					(params at: 2) == (pairParams at: 3)
						ifFalse: [ self error: 'wrong edge vertices between neighbors.' ].
					(params at: 3) == (pairParams at: 2)
						ifFalse: [ self error: 'wrong edge vertices between neighbors.' ] ] ]
]

{ #category : #private }
HGTriangulator >> setOrigin: anHGPoint corner: anotherHGPoint step: aNumber [
	| x0 x1 y0 y1 v1 v2 v3 v4 t1 t2 |
	x0 := anHGPoint x.
	x1 := anotherHGPoint x.
	y0 := anHGPoint y.
	y1 := anotherHGPoint y.
	v1 := HG2dPoint x: x0 y: y0.
	v2 := HG2dPoint x: x1 y: y0.
	v3 := HG2dPoint x: x1 y: y1.
	v4 := HG2dPoint x: x0 y: y1.
	t1 := HG2dTriangle on: v1 on: v2 on: v3.
	t2 := HG2dTriangle on: v3 on: v4 on: v1.
	triangles := IdentityDictionary new: 1000.
	triangles
		at: t1
		put:
			(OrderedCollection
				with:
					(Array
						with: t2
						with: v3
						with: v1
						with: v2
						with: v4)).
	triangles
		at: t2
		put:
			(OrderedCollection
				with:
					(Array
						with: t1
						with: v1
						with: v3
						with: v4
						with: v2))
]

{ #category : #accessing }
HGTriangulator >> triangleAt: anHG2dPoint [
	| bestTriangle bestDepth |
	bestTriangle := nil.
	bestDepth := Float infinity negated.
	triangles associationsDo: [ :assoc | 
			| depth |
			depth := assoc key depth: anHG2dPoint.
			bestDepth < depth
				ifTrue: [ 
					bestDepth := depth.
					bestTriangle := assoc key ] ].
	^ bestTriangle
]

{ #category : #accessing }
HGTriangulator >> trianglesDo: aBlock [
	^ triangles keysDo: aBlock
]
