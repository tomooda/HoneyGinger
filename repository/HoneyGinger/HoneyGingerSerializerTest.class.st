Class {
	#name : 'HoneyGingerSerializerTest',
	#superclass : 'TestCase',
	#instVars : [
		'serializer',
		'buffer',
		'deserializer'
	],
	#category : 'HoneyGinger-Communications-Tests',
	#package : 'HoneyGinger',
	#tag : 'Communications-Tests'
}

{ #category : 'copyrights' }
HoneyGingerSerializerTest class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerSerializerTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerSerializerTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'setups' }
HoneyGingerSerializerTest >> setUp [
	buffer := HoneyGingerTestStream new.
	serializer := HoneyGingerSerializer on: buffer.
	deserializer := HoneyGingerDeserializer on: buffer
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testBinary [
	self try: (0 to: 255 by: 3) asByteArray.
	
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testDict [
	| testData |
	testData := Dictionary new.
	testData at: 1 put: '1'.
	testData at: '2' put: 2.
	testData at: #(3 '4') put: #('3' 4).
	testData at: #[5 6] put: #[7 8].
	testData
		at:
			((Dictionary new)
				at: 1 put: '1';
				yourself)
		put:
			((Dictionary new)
				at: '2' put: 2;
				yourself).
	testData at: nil put: 0.
	testData at: 0 put: nil.
	self try: testData
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testFloat [
	self try: 0.0 accuracy: 0.00001.
	self try: 3.14 accuracy: 0.00001.
	self try: -15.8 accuracy: 0.00001
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testHG2dPoint [
	self try: (HG2dPoint x: 1.0 y: -2.0) accuracy: 0.00001
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testInteger [
	self try: 0.
	self try: 1.
	self try: -2.
	self try: 20 factorial.
	self try: 20 factorial negated
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testList [
	| testData |
	testData := OrderedCollection new.
	testData add: 1.
	testData add: '2'.
	testData add: #(3 '4').
	testData add: #[5 6].
	testData
		add:
			((Dictionary new)
				at: 1 put: '1';
				yourself).
	testData add: nil.
	self try: testData asArray
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testNextN [
	| testData |
	testData := OrderedCollection new.
	testData add: 1.
	testData add: '2'.
	testData add: #(3 '4').
	testData add: #[5 6].
	testData
		add:
			((Dictionary new)
				at: 1 put: '1';
				yourself).
	testData add: nil.
	serializer nextPutAll: testData.
	self assert: testData asArray equals: (deserializer next: testData size)
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testNextPutAll [
	| testData |
	testData := OrderedCollection new.
	testData add: 1.
	testData add: '2'.
	testData add: #(3 '4').
	testData add: #[5 6].
	testData
		add:
			((Dictionary new)
				at: 1 put: '1';
				yourself).
	testData add: nil.
	serializer nextPutAll: testData.
	testData do: [ :datum |
		self assert: datum equals: deserializer next]
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testNil [
	self try: nil
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testScan [
	| testData |
	testData := Dictionary new.
	testData at: 1 put: '1'.
	testData at: '2' put: 2.
	testData at: #(3 '4') put: #('3' 4).
	testData at: #[5 6] put: #[7 8].
	testData
		at:
			((Dictionary new)
				at: 1 put: '1';
				yourself)
		put:
			((Dictionary new)
				at: '2' put: 2;
				yourself).
	testData at: 'point' put: (HG2dPoint x: 1.0 y: -2.0).
	testData at: 'float' put: 2.0.
	testData at: nil put: 0.
	testData at: 0 put: nil.
	serializer write: testData.
	deserializer
		scanDo: [ :key :bytes | 
			(#('point' 'float') includes: key)
				ifTrue: [ self assert: ((testData at: key) - (HoneyGingerDeserializer on: bytes readStream) next) abs < 0.0001 ]
				ifFalse: [ self assert: (testData at: key) equals: (HoneyGingerDeserializer on: bytes readStream) next ] ]
]

{ #category : 'tests' }
HoneyGingerSerializerTest >> testString [
	self try: ''.
	self try: 'this is a string'.
]

{ #category : 'private' }
HoneyGingerSerializerTest >> try: anObject [
	serializer nextPut: anObject.
	self assert: anObject equals: deserializer next
]

{ #category : 'private' }
HoneyGingerSerializerTest >> try: anObject accuracy: aNumber [
	serializer nextPut: anObject.
	self assert: (anObject - deserializer next) abs <= aNumber
]
