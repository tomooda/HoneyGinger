Class {
	#name : #HoneyGingerDeserializer,
	#superclass : #HoneyGingerObjectProtocol,
	#instVars : [
		'indexedObjects'
	],
	#category : 'HoneyGinger-Communications-Serializers'
}

{ #category : #copyrights }
HoneyGingerDeserializer class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerDeserializer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HoneyGingerDeserializer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'initialize-release' }
HoneyGingerDeserializer >> initialize [
	super initialize.
	indexedObjects := OrderedCollection new
]

{ #category : #reading }
HoneyGingerDeserializer >> next [
	^ self readObject
]

{ #category : #reading }
HoneyGingerDeserializer >> next: anInteger [
	| nexts |
	nexts := Array new: anInteger.
	1 to: anInteger do: [ :index | nexts at: index put: self readObject ].
	^ nexts
]

{ #category : #reading }
HoneyGingerDeserializer >> read [
	^ self readDict
]

{ #category : #reading }
HoneyGingerDeserializer >> readBinary: firstByte [
	| byte length bits stopBit bytes |
	byte := firstByte.
	length := byte bitAnd: 2r1111.
	bits := 4.
	stopBit := byte bitAnd: HGBinaryStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			byte := stream next.
			length := length + ((byte bitAnd: 2r1111111) bitShift: bits).
			bits := bits + 7.
			stopBit := byte bitAnd: 2r10000000 ].
	bytes := ByteArray new: length.
	1 to: length do: [ :index | bytes at: index put: stream next ].
	^ bytes
]

{ #category : #reading }
HoneyGingerDeserializer >> readDefine [
	^ indexedObjects addLast: (self readObject)
]

{ #category : #reading }
HoneyGingerDeserializer >> readDict [
	| dict key |
	dict := Dictionary new.
	[ (key := self readObject) ~= HGEndMark ] whileTrue: [ dict at: key put: (self readObject) ].
	^ dict
]

{ #category : #reading }
HoneyGingerDeserializer >> readDo: aBlock [
	| key |
	[ (key := self readObject) ~= HGEndMark ] whileTrue: [ aBlock value: key value: self readObject ]
]

{ #category : #reading }
HoneyGingerDeserializer >> readEnd [
	^ HGEndMark
]

{ #category : #reading }
HoneyGingerDeserializer >> readFloat [
	^ Float
		fromIEEE32Bit:
			((((stream next bitShift: 24) bitOr: (stream next bitShift: 16)) bitOr: (stream next bitShift: 8)) bitOr: stream next)
]

{ #category : #reading }
HoneyGingerDeserializer >> readHG2dPoint [
	^HG2dPoint x: self readFloat y: self readFloat
]

{ #category : #reading }
HoneyGingerDeserializer >> readIndex: firstByte [
	| byte index bits stopBit bytes |
	byte := firstByte.
	index := byte bitAnd: 2r11111.
	bits := 5.
	stopBit := byte bitAnd: HGIndexStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			byte := stream next.
			index := index + ((byte bitAnd: 2r1111111) bitShift: bits).
			bits := bits + 7.
			stopBit := byte bitAnd: 2r10000000 ].
	^ (indexedObjects at: index) deepCopy
]

{ #category : #reading }
HoneyGingerDeserializer >> readInteger: firstByte [
	| byte sign integer bits stopBit bytes |
	byte := firstByte.
	sign := byte bitAnd: HGIntegerSignBit.
	integer := byte bitAnd: 2r11111.
	bits := 5.
	stopBit := byte bitAnd: HGIntegerStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			byte := stream next.
			integer := integer + ((byte bitAnd: 2r1111111) bitShift: bits).
			bits := bits + 7.
			stopBit := byte bitAnd: 2r10000000 ].
	^ sign = 0
		ifTrue: [ integer ]
		ifFalse: [ integer negated ]
]

{ #category : #reading }
HoneyGingerDeserializer >> readList [
	| buffer object |
	buffer := Array new writeStream.
	[ (object := self readObject) ~= HGEndMark ] whileTrue: [ buffer nextPut: object ].
	^ buffer contents
]

{ #category : #reading }
HoneyGingerDeserializer >> readNil [
	^ nil
]

{ #category : #reading }
HoneyGingerDeserializer >> readObject [
	^self readObject: stream next
]

{ #category : #reading }
HoneyGingerDeserializer >> readObject: firstByte [
	| selector |
	selector := #(#readEnd #readFloat #readString #readList #readDict #readDefine #readNil)
		at: firstByte + 1
		ifAbsent: [  ].
	selector ifNotNil: [ ^ self perform: selector ].
	(firstByte bitAnd: HGIntegerType) ~= 0
		ifTrue: [ ^ self readInteger: firstByte ].
	(firstByte bitAnd: HGIndexType) ~= 0
		ifTrue: [ ^ self readIndex: firstByte ].
	(firstByte bitAnd: HGBinaryType) ~= 0
		ifTrue: [ ^ self readBinary: firstByte ].
	firstByte = HG2dPointType 
		ifTrue: [ ^ self readHG2dPoint ].
	^ self error: 'Undefined type in the stream'
]

{ #category : #reading }
HoneyGingerDeserializer >> readString [
	| buffer code |
	buffer := String new writeStream.
	[ (code := stream next) ~= HGEndMarkType ] whileTrue: [ buffer nextPut: (Character value: code) ].
	^ buffer contents
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanBinary: firstByte into: destStream [
	| byte length bits stopBit |
	byte := firstByte.
	length := byte bitAnd: 2r1111.
	bits := 4.
	stopBit := byte bitAnd: HGBinaryStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			destStream nextPut: (byte := stream next).
			length := length + ((byte bitAnd: 2r1111111) bitShift: bits).
			bits := bits + 7.
			stopBit := byte bitAnd: 2r10000000 ].
	length timesRepeat: [ destStream nextPut: stream next ]
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanDefineInto: destStream [
	self scanObjectInto: destStream
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanDictInto: destStream [
	[ (self scanObjectInto: destStream) ~= HGEndMark ] whileTrue: [ self scanObjectInto: destStream ]
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanDo: aBlock [
	| key |
	[ (key := self readObject) ~= HGEndMark ]
		whileTrue: [ 
			| buffer |
			buffer := ByteArray new writeStream.
			self scanObjectInto: buffer.
			aBlock value: key value: buffer contents ]
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanEndInto: destStream [
	^ HGEndMark
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanFloatInto: destStream [
	destStream nextPut: stream next.
	destStream nextPut: stream next.
	destStream nextPut: stream next.
	destStream nextPut: stream next
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanHG2dPointInto: destStream [
	self scanFloatInto: destStream.
	self scanFloatInto: destStream
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanIndex: firstByte into: destStream [
	| stopBit byte |
	stopBit := firstByte bitAnd: HGIndexStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			destStream nextPut: (byte := stream next).
			stopBit := byte bitAnd: 2r10000000 ]
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanInteger: firstByte into: destStream [
	| byte stopBit |
	byte := firstByte.
	stopBit := byte bitAnd: HGIntegerStopBit.
	[ stopBit = 0 ]
		whileTrue: [ 
			destStream nextPut: (byte := stream next).
			stopBit := byte bitAnd: 2r10000000 ]
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanListInto: destStream [
	[ (self scanObjectInto: destStream) ~= HGEndMark ] whileTrue
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanNilInto: destStream [
	"well, nothing to do... that's my trouble..."
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanObject: firstByte into: destStream [
	| selector |
	selector := #(#scanEndInto: #scanFloatInto: #scanStringInto: #scanListInto: #scanDictInto: #scanDefineInto: #scanNilInto:)
		at: firstByte + 1
		ifAbsent: [  ].
	selector ifNotNil: [ ^ self perform: selector with: destStream ].
	(firstByte bitAnd: HGIntegerType) ~= 0
		ifTrue: [ ^ self scanInteger: firstByte into: destStream ].
	(firstByte bitAnd: HGIndexType) ~= 0
		ifTrue: [ ^ self scanIndex: firstByte into: destStream ].
	(firstByte bitAnd: HGBinaryType) ~= 0
		ifTrue: [ ^ self scanBinary: firstByte into: destStream ].
	firstByte = HG2dPointType 
		ifTrue: [ ^self scanHG2dPointInto: destStream ].
	^ self error: 'Undefined type in the stream'
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanObjectInto: destStream [
	| byte |
	destStream nextPut: (byte := stream next).
	^ self scanObject: byte into: destStream
]

{ #category : #scanning }
HoneyGingerDeserializer >> scanStringInto: destStream [
	[ 
	| code |
	destStream nextPut: (code := stream next).
	code ~= HGEndMarkType ] whileTrue
]
