Class {
	#name : 'HoneyGingerObjectProtocol',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#classVars : [
		'HG2dPointType',
		'HGBinaryStopBit',
		'HGBinaryType',
		'HGDefineType',
		'HGDictType',
		'HGEndMark',
		'HGEndMarkType',
		'HGFloatType',
		'HGIndexStopBit',
		'HGIndexType',
		'HGIntegerSignBit',
		'HGIntegerStopBit',
		'HGIntegerType',
		'HGListType',
		'HGNilType',
		'HGStringType'
	],
	#category : 'HoneyGinger-Communications-Serializers',
	#package : 'HoneyGinger',
	#tag : 'Communications-Serializers'
}

{ #category : 'copyrights' }
HoneyGingerObjectProtocol class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerObjectProtocol class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'class initialization' }
HoneyGingerObjectProtocol class >> initialize [
	"PcardObjectProtocol initialize"

	super initialize.
	HGEndMarkType := 2r00000000.
	HGFloatType := 2r00000001.
	HGStringType := 2r00000010.
	HGListType := 2r00000011.
	HGDictType := 2r00000100.
	HGDefineType := 2r00000101.
	HGNilType := 2r00000110.
	HGBinaryType := 2r00100000.
	HGBinaryStopBit := 2r00010000.
	HGIndexType := 2r01000000.
	HGIndexStopBit := 2r00100000.
	HGIntegerType := 2r10000000.
	HGIntegerSignBit := 2r01000000.
	HGIntegerStopBit := 2r00100000.
	HG2dPointType := 2r00010000.
	HGEndMark := Object new
]

{ #category : 'instance creation' }
HoneyGingerObjectProtocol class >> on: aStream [
	^ self new setStream: aStream
]

{ #category : 'copyrights' }
HoneyGingerObjectProtocol class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'private' }
HoneyGingerObjectProtocol >> setStream: aStream [
	stream := aStream
]
