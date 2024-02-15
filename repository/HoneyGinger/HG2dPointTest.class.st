Class {
	#name : 'HG2dPointTest',
	#superclass : 'TestCase',
	#category : 'HoneyGinger-Geometry-Tests',
	#package : 'HoneyGinger',
	#tag : 'Geometry-Tests'
}

{ #category : 'copyrights' }
HG2dPointTest class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HG2dPointTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HG2dPointTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'asserting' }
HG2dPointTest >> assert: expected equals: actual accuracy: acceptableError [
	self assert: (expected - actual) abs <= acceptableError
]

{ #category : 'asserting' }
HG2dPointTest >> assert: expected equals: actual pointAccuracy: accuracy [
	self assert: (actual - expected) r abs < accuracy
]

{ #category : 'tests' }
HG2dPointTest >> testAbs [
	self assert: 3.0 equals: (HG2dPoint x: 1.0 y: -2.0) abs accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testAddBy [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point add: (HG2dPoint x: 3.0 y: 4.0) by: 5.0.
	self assert: (HG2dPoint x: 16.0 y: 22.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testAddMinusBy [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point add: (HG2dPoint x: 3.0 y: 4.0) minus: (HG2dPoint x: 5.0 y: 7.0) by: 5.0.
	self assert: (HG2dPoint x: -9.0 y: -13.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testAddOver [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point add: (HG2dPoint x: 3.0 y: 4.0) over: 2.0.
	self assert: (HG2dPoint x: 2.5 y: 4.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testAsPoint [
	self assert: 1@2 equals: (HG2dPoint x: 1 y: 2) asPoint pointAccuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testCeiling [
	self assert: (HG2dPoint x: 2 y: 3) equals: (HG2dPoint x: 1.1 y: 2.8) ceiling
]

{ #category : 'tests' }
HG2dPointTest >> testCornerDo [
	| points |
	points := Array new writeStream.
	(HG2dPoint x: 1 y: 2) corner: (HG2dPoint x: 3 y: 4) do: [ :point | points nextPut: point ].
	self
		assert:
			{(HG2dPoint x: 1 y: 2).
			(HG2dPoint x: 1 y: 3).
			(HG2dPoint x: 1 y: 4).
			(HG2dPoint x: 2 y: 2).
			(HG2dPoint x: 2 y: 3).
			(HG2dPoint x: 2 y: 4).
			(HG2dPoint x: 3 y: 2).
			(HG2dPoint x: 3 y: 3).
			(HG2dPoint x: 3 y: 4)}
		equals: points contents
]

{ #category : 'tests' }
HG2dPointTest >> testCornerElementsDo [
	| points |
	points := Array new writeStream.
	(HG2dPoint x: 1 y: 2) corner: (HG2dPoint x: 3 y: 4) elementsDo: [ :x :y | points nextPut: (HG2dPoint x: x y: y) ].
	self
		assert:
			{(HG2dPoint x: 1 y: 2).
			(HG2dPoint x: 1 y: 3).
			(HG2dPoint x: 1 y: 4).
			(HG2dPoint x: 2 y: 2).
			(HG2dPoint x: 2 y: 3).
			(HG2dPoint x: 2 y: 4).
			(HG2dPoint x: 3 y: 2).
			(HG2dPoint x: 3 y: 3).
			(HG2dPoint x: 3 y: 4)}
		equals: points contents
]

{ #category : 'tests' }
HG2dPointTest >> testDimensions [
	self assert: 2 equals: (HG2dPoint x: 3 y: 4) dimensions 
]

{ #category : 'tests' }
HG2dPointTest >> testDistance [
	self
		assert: 2.0
		equals: ((HG2dPoint x: 1 y: 2) distance: (HG2dPoint x: 1 y: 2) + (HG2dPoint theta: 1.0 r: 2.0))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testDiv [
	| point |
	point := HG2dPoint x: 1.0 y: 3.0.
	point div: 2.0.
	self assert: (HG2dPoint x: 0.5 y: 1.5) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testDot [
	self assert: 7 equals: ((HG2dPoint x: 1 y: 2) dot: (HG2dPoint x: -3 y: 5))
]

{ #category : 'tests' }
HG2dPointTest >> testEqual [
	| center |
	center := HG2dPoint x: 0.0 y: 0.0.
	self deny: center = (HG2dPoint x: 1.0 y: 1.0).
	self deny: center = (HG2dPoint x: 1.0 y: 0.0).
	self deny: center = (HG2dPoint x: 1.0 y: -1.0).
	self deny: center = (HG2dPoint x: 0.0 y: 1.0).
	self assert: center = (HG2dPoint x: 0.0 y: 0.0).
	self deny: center = (HG2dPoint x: 0.0 y: -1.0).
	self deny: center = (HG2dPoint x: -1.0 y: 1.0).
	self deny: center = (HG2dPoint x: -1.0 y: 0.0).
	self deny: center = (HG2dPoint x: -1.0 y: -1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testFloor [
	self assert: (HG2dPoint x: 1 y: 2) equals: (HG2dPoint x: 1.1 y: 2.8) floor
]

{ #category : 'tests' }
HG2dPointTest >> testGreaterOrEqual [
	| center |
	center := HG2dPoint x: 0.0 y: 0.0.
	self deny: center >= (HG2dPoint x: 1.0 y: 1.0).
	self deny: center >= (HG2dPoint x: 1.0 y: 0.0).
	self deny: center >= (HG2dPoint x: 1.0 y: -1.0).
	self deny: center >= (HG2dPoint x: 0.0 y: 1.0).
	self assert: center >= (HG2dPoint x: 0.0 y: 0.0).
	self assert: center >= (HG2dPoint x: 0.0 y: -1.0).
	self deny: center >= (HG2dPoint x: -1.0 y: 1.0).
	self assert: center >= (HG2dPoint x: -1.0 y: 0.0).
	self assert: center >= (HG2dPoint x: -1.0 y: -1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testGreaterThan [
	| center |
	center := HG2dPoint x: 0.0 y: 0.0.
	self deny: center > (HG2dPoint x: 1.0 y: 1.0).
	self deny: center > (HG2dPoint x: 1.0 y: 0.0).
	self deny: center > (HG2dPoint x: 1.0 y: -1.0).
	self deny: center > (HG2dPoint x: 0.0 y: 1.0).
	self deny: center > (HG2dPoint x: 0.0 y: 0.0).
	self deny: center > (HG2dPoint x: 0.0 y: -1.0).
	self deny: center > (HG2dPoint x: -1.0 y: 1.0).
	self deny: center > (HG2dPoint x: -1.0 y: 0.0).
	self assert: center > (HG2dPoint x: -1.0 y: -1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testHash [
	self assert: (HG2dPoint x: 1 y: 2) hash equals: (HG2dPoint x: 1 y: 2) hash.
	self assert: (HG2dPoint x: 1.0 y: 2.0) hash equals: (HG2dPoint x: 1.0 y: 2.0) hash
]

{ #category : 'tests' }
HG2dPointTest >> testInRadius1 [
	| point1 point2 |
	point1 := HG2dPoint x: 1.0 y: 2.0.
	point2 := point1 + (HG2dPoint theta: 1.0 r: 2.0).
	self assert: (point1 in: point2 radius: 3.0)
]

{ #category : 'tests' }
HG2dPointTest >> testInRadius2 [
	| point1 point2 |
	point1 := HG2dPoint x: 1.0 y: 2.0.
	point2 := point1 + (HG2dPoint theta: 1.0 r: 2.0).
	self deny: (point1 in: point2 radius: 1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testIndexIn [
	| corner indices |
	corner := HG2dPoint x: 10 y: 10.
	indices := Array new writeStream.
	(HG2dPoint x: 0 y: 0) corner: (HG2dPoint x: 9 y: 9) do: [ :point | indices nextPut: (point indexIn: corner) ].
	self assert: (1 to: 100) asArray equals: indices contents
]

{ #category : 'tests' }
HG2dPointTest >> testLaplace [
	| field |
	field := [ :point | (point x * point x) + (point y * point y) ].
	self assert: 4.0 equals: ((HG2dPoint x: 0.0 y: 0.0) laplace: field delta: 0.01) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testLength1 [
	self assert: (HG2dPoint theta: 1.0 r: 3.0) equals: ((HG2dPoint theta: 1.0 r: 2.0) length: 3.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testLength2 [
	self assert: 2.0 equals: (HG2dPoint theta: 1.0 r: 2.0) length accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testLessOrEqual [
	| center |
	center := HG2dPoint x: 0.0 y: 0.0.
	self assert: center <= (HG2dPoint x: 1.0 y: 1.0).
	self assert: center <= (HG2dPoint x: 1.0 y: 0.0).
	self deny: center <= (HG2dPoint x: 1.0 y: -1.0).
	self assert: center <= (HG2dPoint x: 0.0 y: 1.0).
	self assert: center <= (HG2dPoint x: 0.0 y: 0.0).
	self deny: center <= (HG2dPoint x: 0.0 y: -1.0).
	self deny: center <= (HG2dPoint x: -1.0 y: 1.0).
	self deny: center <= (HG2dPoint x: -1.0 y: 0.0).
	self deny: center <= (HG2dPoint x: -1.0 y: -1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testLessThan [
	| center |
	center := HG2dPoint x: 0.0 y: 0.0.
	self assert: center < (HG2dPoint x: 1.0 y: 1.0).
	self deny: center < (HG2dPoint x: 1.0 y: 0.0).
	self deny: center < (HG2dPoint x: 1.0 y: -1.0).
	self deny: center < (HG2dPoint x: 0.0 y: 1.0).
	self deny: center < (HG2dPoint x: 0.0 y: 0.0).
	self deny: center < (HG2dPoint x: 0.0 y: -1.0).
	self deny: center < (HG2dPoint x: -1.0 y: 1.0).
	self deny: center < (HG2dPoint x: -1.0 y: 0.0).
	self deny: center < (HG2dPoint x: -1.0 y: -1.0)
]

{ #category : 'tests' }
HG2dPointTest >> testMinMax1 [
	self
		assert: (HG2dPoint x: 1.0 y: 2.0)
		equals: ((HG2dPoint x: 1.0 y: 2.0) min: (HG2dPoint x: 2.0 y: 3.0) max: (HG2dPoint x: 0.0 y: 1.0))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testMinMax2 [
	self
		assert: (HG2dPoint x: 0.5 y: 2.0)
		equals: ((HG2dPoint x: 1.0 y: 2.0) min: (HG2dPoint x: 0.5 y: 3.0) max: (HG2dPoint x: 0.0 y: 1.0))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testMinMax3 [
	self
		assert: (HG2dPoint x: 1.5 y: 2.0)
		equals: ((HG2dPoint x: 1.0 y: 2.0) min: (HG2dPoint x: 2.0 y: 3.0) max: (HG2dPoint x: 1.5 y: 1.0))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testMinMax4 [
	self
		assert: (HG2dPoint x: 1.0 y: 1.5)
		equals: ((HG2dPoint x: 1.0 y: 2.0) min: (HG2dPoint x: 2.0 y: 1.5) max: (HG2dPoint x: 0.0 y: 1.0))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testMinMax5 [
	self
		assert: (HG2dPoint x: 1.0 y: 2.5)
		equals: ((HG2dPoint x: 1.0 y: 2.0) min: (HG2dPoint x: 2.0 y: 3.0) max: (HG2dPoint x: 0.0 y: 2.5))
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testMinus [
	| point |
	point := (HG2dPoint x: 2.0 y: 3.0) - (HG2dPoint x: 4.0 y: 7.0).
	self assert: -2.0 equals: point x accuracy: 1.0e-8.
	self assert: -4.0 equals: point y accuracy: 1.0e-8.
	
]

{ #category : 'tests' }
HG2dPointTest >> testMul [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point mul: 3.0.
	self assert: (HG2dPoint x: 3.0 y: 6.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testNorm1 [
	self assert: 3.0 equals: (HG2dPoint x: 1.0 y: -2.0) norm1
]

{ #category : 'tests' }
HG2dPointTest >> testNorm2 [
	self assert: 2.0 equals: (HG2dPoint theta: 1.0 r: 2.0) norm2 accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testNorm3 [
	self assert: (9.0 raisedTo: 1.0 / 3.0) equals: ((HG2dPoint x: 1.0 y: 2.0) norm: 3.0) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testPlus [
	| point |
	point := (HG2dPoint x: 2.0 y: 3.0) + (HG2dPoint x: 4.0 y: 5.0).
	self assert: 6.0 equals: point x accuracy: 1.0e-8.
	self assert: 8.0 equals: point y accuracy: 1.0e-8.
	
]

{ #category : 'tests' }
HG2dPointTest >> testPlusBy [
	self
		assert: (HG2dPoint x: 16.0 y: 22.0)
		equals: ((HG2dPoint x: 1.0 y: 2.0) plus: (HG2dPoint x: 3.0 y: 4.0) by: 5.0)
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testPlusOver [
	self
		assert: (HG2dPoint x: 16.0 y: 22.0)
		equals: ((HG2dPoint x: 1.0 y: 2.0) plus: (HG2dPoint x: 3.0 y: 4.0) over: 0.2)
		accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testProduct [
	self assert: 6 equals: (HG2dPoint x: 2 y: 3) product
]

{ #category : 'tests' }
HG2dPointTest >> testQuo [
	| point |
	point := (HG2dPoint x: 4 y: 13) // 2.
	self assert: 2 equals: point x.
	self assert: 6 equals: point y
]

{ #category : 'tests' }
HG2dPointTest >> testR [
	self assert: 2.0 equals: (HG2dPoint theta: 1.0 r: 2.0) r accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testSet [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point set: (HG2dPoint x: 3.0 y: 4.0).
	self assert: (HG2dPoint x: 3.0 y: 4.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testSetXY [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point setX: 3.0 y: 4.0.
	self assert: (HG2dPoint x: 3.0 y: 4.0) equals: point accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testSlash [
	| point |
	point := (HG2dPoint x: 2.0 y: 3.0) / 4.0.
	self assert: 0.5 equals: point x accuracy: 1.0e-8.
	self assert: 0.75 equals: point y accuracy: 1.0e-8.
	
]

{ #category : 'tests' }
HG2dPointTest >> testStar [
	| point |
	point := (HG2dPoint x: 2.0 y: 3.0) * 4.0.
	self assert: 8.0 equals: point x accuracy: 1.0e-8.
	self assert: 12.0 equals: point y accuracy: 1.0e-8.
	
]

{ #category : 'tests' }
HG2dPointTest >> testTheta1 [
	self assert: 1.0 equals: (HG2dPoint theta: 1.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta2 [
	self assert: 2.0 equals: (HG2dPoint theta: 2.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta3 [
	self assert: 3.0 equals: (HG2dPoint theta: 3.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta4 [
	self assert: 4.0 equals: (HG2dPoint theta: 4.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta5 [
	self assert: 5.0 equals: (HG2dPoint theta: 5.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta6 [
	self assert: 6.0 equals: (HG2dPoint theta: 6.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testTheta7 [
	self assert: 7.0 - (Float pi * 2.0) equals: (HG2dPoint theta: 7.0 r: 2.0) theta accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToConflictsWithLineSegmentTo1 [
	| from1 to1 from2 to2 |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	from2 := HG2dPoint x: 1.0 y: 4.0.
	to2 := HG2dPoint x: 2.0 y: 2.0.
	self assert: (from1 to: to1 conflictsWithLineSegment: from2 to: to2)
]

{ #category : 'tests' }
HG2dPointTest >> testToConflictsWithLineSegmentTo2 [
	| from1 to1 from2 to2 |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	from2 := HG2dPoint x: 1.0 y: 1.0.
	to2 := HG2dPoint x: 0.0 y: 4.0.
	self deny: (from1 to: to1 conflictsWithLineSegment: from2 to: to2)
]

{ #category : 'tests' }
HG2dPointTest >> testToConflictsWithLineSegmentTo3 [
	| from1 to1 from2 to2 |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	from2 := HG2dPoint x: 1.5 y: 5.0.
	to2 := HG2dPoint x: 1.5 y: 6.0.
	self deny: (from1 to: to1 conflictsWithLineSegment: from2 to: to2)
]

{ #category : 'tests' }
HG2dPointTest >> testToContains1 [
	| from1 to1 point |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	point := HG2dPoint x: 1.5 y: 3.0.
	self assert: (from1 to: to1 contains: point)
]

{ #category : 'tests' }
HG2dPointTest >> testToContains2 [
	| from1 to1 point |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	point := HG2dPoint x: 1.0 y: 2.0.
	self assert: (from1 to: to1 contains: point)
]

{ #category : 'tests' }
HG2dPointTest >> testToContains3 [
	| from1 to1 point |
	from1 := HG2dPoint x: 1.0 y: 2.0.
	to1 := HG2dPoint x: 2.0 y: 4.0.
	point := HG2dPoint x: 1.5 y: 3.5.
	self deny: (from1 to: to1 contains: point)
]

{ #category : 'tests' }
HG2dPointTest >> testToCross [
	| from alpha beta to point |
	from := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := 0.5.
	to := from + (HG2dPoint theta: alpha r: 1.0).
	point := from + (HG2dPoint theta: alpha + beta r: 1.0).
	self assert: beta sin equals: (from to: to cross: point) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointTo1 [
	| crossPoint alpha beta from1 to1 from2 to2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := 2.5.
	from1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to1 := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	from2 := crossPoint + (HG2dPoint theta: beta r: 1.0).
	to2 := crossPoint + (HG2dPoint theta: beta + Float pi r: 1.0).
	self assert: crossPoint equals: (from1 to: to1 crossPoint: from2 to: to2) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointTo2 [
	self
		assert:
			((HG2dPoint x: 1.0 y: 2.0)
				to: (HG2dPoint x: 2.0 y: 4.0)
				crossPoint: (HG2dPoint x: -1.0 y: 2.0)
				to: (HG2dPoint x: -2.0 y: 4.0)) isNil
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointTo3 [
	self
		assert:
			((HG2dPoint x: 1.0 y: 2.0)
				to: (HG2dPoint x: 2.0 y: 4.0)
				crossPoint: (HG2dPoint x: 3.0 y: 2.0)
				to: (HG2dPoint x: 4.0 y: 4.0)) isNil
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointTo4 [
	self
		assert:
			((HG2dPoint x: 1.0 y: 2.0)
				to: (HG2dPoint x: 2.0 y: 4.0)
				crossPoint: (HG2dPoint x: 1.0 y: 3.0)
				to: (HG2dPoint x: 2.0 y: 5.0)) isNil
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointX1 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: crossPoint x equals: (from to: to crossPointX: crossPoint x) x accuracy: 1.0e-8.
	self assert: crossPoint y equals: (from to: to crossPointX: crossPoint x) y accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointX2 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: (from to: to crossPointX: 3.0) isNil.

]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointX3 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: (from to: to crossPointX: -3.0) isNil.

]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointY1 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: crossPoint x equals: (from to: to crossPointY: crossPoint y) x accuracy: 1.0e-8.
	self assert: crossPoint y equals: (from to: to crossPointY: crossPoint y) y accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointY2 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: (from to: to crossPointY: 3.0) isNil.

]

{ #category : 'tests' }
HG2dPointTest >> testToCrossPointY3 [
	| crossPoint alpha from to |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 1.0).
	self assert: (from to: to crossPointY: -3.0) isNil.

]

{ #category : 'tests' }
HG2dPointTest >> testToDistance1 [
	| crossPoint alpha beta from to point |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi / 2.0 + alpha.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 2.0).
	point := crossPoint + (HG2dPoint theta: beta r: 3.0).
	self assert: 3.0 equals: (from to: to distance: point) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToDistance2 [
	| crossPoint alpha beta point1 point2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi + alpha + 0.1.
	point1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	point2 := crossPoint + (HG2dPoint theta: beta r: 2.0).
	self assert: 2.0 equals: (crossPoint to: point1 distance: point2) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToDistance3 [
	| crossPoint alpha beta point1 point2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi + alpha + 0.1.
	point1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	point2 := crossPoint + (HG2dPoint theta: beta r: 2.0).
	self assert: 1.0 equals: (crossPoint to: point2 distance: point1) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToDot [
	| crossPoint alpha beta point1 point2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi + alpha + 0.1.
	point1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	point2 := crossPoint + (HG2dPoint theta: beta r: 2.0).
	self assert: (point1 - crossPoint dot: point2 - crossPoint) equals: (crossPoint to: point2 dot: point1) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToNearestFrom1 [
	| crossPoint alpha beta from to point |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi / 2.0 + alpha.
	from := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	to := crossPoint + (HG2dPoint theta: alpha + Float pi r: 2.0).
	point := crossPoint + (HG2dPoint theta: beta r: 3.0).
	self assert: crossPoint equals: (from to: to nearestFrom: point) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToNearestFrom2 [
	| crossPoint alpha beta point1 point2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi + alpha + 0.1.
	point1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	point2 := crossPoint + (HG2dPoint theta: beta r: 2.0).
	self assert: crossPoint equals: (crossPoint to: point1 nearestFrom: point2) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testToNearestFrom3 [
	| crossPoint alpha beta point1 point2 |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	beta := Float pi + alpha + 0.1.
	point1 := crossPoint + (HG2dPoint theta: alpha r: 1.0).
	point2 := crossPoint + (HG2dPoint theta: beta r: 2.0).
	self assert: crossPoint equals: (crossPoint to: point2 nearestFrom: point1) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testUnit [
	self assert: (HG2dPoint theta: 1.0 r: 1.0) equals: (HG2dPoint theta: 1.0 r: 2.0) unit accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testUnitVector [
	| crossPoint alpha point unit |
	crossPoint := HG2dPoint x: 1.0 y: 2.0.
	alpha := 1.0.
	point := crossPoint + (HG2dPoint theta: alpha r: 2.0).
	unit := HG2dPoint theta: alpha r: 1.0.
	self assert: unit equals: (crossPoint unitVector: point) accuracy: 1.0e-8
]

{ #category : 'tests' }
HG2dPointTest >> testX1 [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	self assert: 1.0 equals: point x accuracy: 1.0e-8	
]

{ #category : 'tests' }
HG2dPointTest >> testX2 [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point x: 3.0.
	self assert: 3.0 equals: point x accuracy: 1.0e-8.
	
]

{ #category : 'tests' }
HG2dPointTest >> testY1 [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	self assert: 2.0 equals: point y accuracy: 1.0e-8	
]

{ #category : 'tests' }
HG2dPointTest >> testY2 [
	| point |
	point := HG2dPoint x: 1.0 y: 2.0.
	point y: 3.0.
	self assert: 3.0 equals: point y accuracy: 1.0e-8.
	
]
