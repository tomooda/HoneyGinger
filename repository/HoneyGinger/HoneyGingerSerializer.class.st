Class {
	#name : 'HoneyGingerSerializer',
	#superclass : 'HoneyGingerObjectProtocol',
	#instVars : [
		'selectors'
	],
	#category : 'HoneyGinger-Communications-Serializers',
	#package : 'HoneyGinger',
	#tag : 'Communications-Serializers'
}

{ #category : 'copyrights' }
HoneyGingerSerializer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerSerializer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'examples' }
HoneyGingerSerializer class >> example1 [
	"PcardSerializer example1"

	| testdata stream serializer |
	testdata := OrderedCollection new.
	testdata add: 123.4.
	stream := ByteArray new writeStream.
	serializer := HoneyGingerSerializer on: stream.
	testdata do: [ :data | serializer writeObject: data ].
	^ stream contents
]

{ #category : 'examples' }
HoneyGingerSerializer class >> example2 [
	"PcardSerializer example2"

	| testdata stream serializer bytes buffer scanner deserializer |
	testdata := Dictionary new.
	testdata at: 1 put: #(1 2 3).
	testdata at: 'abc' put: (Dictionary new at: 'xyz' put: -1; yourself).
	stream := ByteArray new writeStream.
	serializer := HoneyGingerSerializer on: stream.
	serializer write: testdata.
	bytes := stream contents.
	buffer := Dictionary new.
	scanner := HoneyGingerDeserializer on: bytes readStream.
	scanner scanDo: [ :key :value | buffer at: key put: value ].
	stream := ByteArray new writeStream.
	serializer := HoneyGingerSerializer on: stream.
	buffer keysAndValuesDo: [ :key :value | serializer writeObject: key. stream nextPutAll: value].
	serializer writeEnd.
	deserializer := HoneyGingerDeserializer on: stream contents readStream.
	^deserializer read
]

{ #category : 'copyrights' }
HoneyGingerSerializer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'initialize-release' }
HoneyGingerSerializer >> initialize [
	super initialize.
	selectors := IdentityDictionary new.
	selectors at: #Float put: #writeFloat:.
	selectors at: #String put: #writeString:.
	selectors at: #Array put: #writeList:.
	selectors at: #OrderedCollection put: #writeList:.
	selectors at: #Collection put: #writeList:.
	selectors at: #Dictionary put: #writeDict:.
	selectors at: #IdentityDictionary put: #writeDict:.
	selectors at: #ByteArray put: #writeBinary:.
	selectors at: #LargePositiveInteger put: #writeInteger:.
	selectors at: #LargeNegativeInteger put: #writeInteger:.
	selectors at: #SmallInteger put: #writeInteger:.
	selectors at: #UndefinedObject put: #writeNil:.
	selectors at: #HG2dPoint put: #writeHG2dPoint:
]

{ #category : 'writing' }
HoneyGingerSerializer >> nextPut: anObject [
	self writeObject: anObject.
	^ anObject
]

{ #category : 'writing' }
HoneyGingerSerializer >> nextPutAll: aCollection [
	aCollection do: [ :object | self nextPut: object ].
	^ aCollection
]

{ #category : 'accessing' }
HoneyGingerSerializer >> searchSelectorFor: anObject [
	| class |
	class := anObject class.
	[ class notNil ]
		whileTrue: [ 
			(selectors includesKey: class name)
				ifTrue: [ ^ selectors at: class name ].
			class := class superclass ].
	^ self error: 'Unsupported type'
]

{ #category : 'writing' }
HoneyGingerSerializer >> write: aKeyedCollection [
	aKeyedCollection
		keysAndValuesDo: [ :key :value | 
			self writeObject: key.
			self writeObject: value ].
	self writeEnd
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeBinary: aByteArray [
	| length first4bits stopBit |
	length := aByteArray size.
	first4bits := length bitAnd: 2r1111.
	stopBit := first4bits = length
		ifTrue: [ HGBinaryStopBit ]
		ifFalse: [ 0 ].
	stream nextPut: ((HGBinaryType bitOr: stopBit) bitOr: first4bits).
	length := length >> 4.
	[ stopBit = 0 ]
		whileTrue: [ 
			| first7bits |
			first7bits := length bitAnd: 2r1111111.
			stopBit := first7bits = length
				ifTrue: [ 2r10000000 ]
				ifFalse: [ 0 ].
			stream nextPut: (stopBit bitOr: first7bits).
			length := length >> 7 ].
	stream nextPutAll: aByteArray
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeDefine [
	stream nextPut: HGDefineType
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeDict: aDictionary [
	stream nextPut: HGDictType.
	aDictionary keysAndValuesDo: [ :key :value |
		self writeObject: key.
		self writeObject: value].
	stream nextPut: HGEndMarkType
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeEnd [
	^ stream nextPut: HGEndMarkType
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeFloat: aFloat [
	| bits |
	bits := aFloat asIEEE32BitWord.
	stream nextPut: HGFloatType.
	stream nextPut: (bits bitShift: -24).
	stream nextPut: ((bits bitShift: -16) bitAnd: 255).
	stream nextPut: ((bits bitShift: -8) bitAnd: 255).
	stream nextPut: (bits bitAnd: 255)
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeHG2dPoint: aHG2dPoint [
	| bits |
	stream nextPut: 2r00010000.
	bits := aHG2dPoint x asFloat asIEEE32BitWord.
	stream nextPut: (bits bitShift: -24).
	stream nextPut: ((bits bitShift: -16) bitAnd: 255).
	stream nextPut: ((bits bitShift: -8) bitAnd: 255).
	stream nextPut: (bits bitAnd: 255).
	bits := aHG2dPoint y asFloat asIEEE32BitWord.
	stream nextPut: (bits bitShift: -24).
	stream nextPut: ((bits bitShift: -16) bitAnd: 255).
	stream nextPut: ((bits bitShift: -8) bitAnd: 255).
	stream nextPut: (bits bitAnd: 255)
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeIndex: anInteger [
	| index first5bits stopBit |
	index := anInteger.
	first5bits := index bitAnd: 2r11111.
	stopBit := first5bits = index
		ifTrue: [ HGIndexStopBit ]
		ifFalse: [ 0 ].
	stream nextPut: ((HGIndexType bitOr: stopBit) bitOr: first5bits).
	index := index >> 5.
	[ stopBit = 0 ]
		whileTrue: [ 
			| first7bits |
			first7bits := index bitAnd: 2r1111111.
			stopBit := first7bits = index
				ifTrue: [ 2r10000000 ]
				ifFalse: [ 0 ].
			stream nextPut: (stopBit bitOr: first7bits).
			index := index >> 7 ]
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeInteger: anInteger [
	| integer  signBit first5bits stopBit |
	integer := anInteger abs.
	signBit := anInteger < 0 ifTrue: [HGIntegerSignBit]  ifFalse: [0].
	first5bits := integer bitAnd: 2r11111.
	stopBit := first5bits = integer
		ifTrue: [ HGIntegerStopBit ]
		ifFalse: [ 0 ].
	stream nextPut: (((HGIntegerType bitOr: signBit) bitOr: stopBit) bitOr: first5bits).
	integer := integer >> 5.
	[ stopBit = 0 ]
		whileTrue: [ 
			| first7bits |
			first7bits := integer bitAnd: 2r1111111.
			stopBit := first7bits = integer
				ifTrue: [ 2r10000000 ]
				ifFalse: [ 0 ].
			stream nextPut: (stopBit bitOr: first7bits).
			integer := integer >> 7 ]
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeList: aCollection [
	stream nextPut: HGListType.
	aCollection do: [ :object | self writeObject: object].
	stream nextPut: HGEndMarkType
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeNil: nilObject [
	stream nextPut: HGNilType 
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeObject: anObject [
	self perform: (selectors at: anObject class name ifAbsentPut: [ self searchSelectorFor: anObject ]) with: anObject
]

{ #category : 'writing' }
HoneyGingerSerializer >> writeString: aString [
	stream nextPut: HGStringType.
	stream nextPutAll: aString asByteArray.
	stream nextPut: HGEndMarkType
]
