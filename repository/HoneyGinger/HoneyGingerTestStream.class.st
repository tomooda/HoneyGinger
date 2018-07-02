Class {
	#name : #HoneyGingerTestStream,
	#superclass : #Stream,
	#instVars : [
		'bytes',
		'readIndex',
		'writeIndex',
		'readSemaphore'
	],
	#category : 'HoneyGinger-Communications-Tests'
}

{ #category : #copyrights }
HoneyGingerTestStream class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerTestStream class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HoneyGingerTestStream class >> new [
	^ (self basicNew)
		initialize;
		yourself
]

{ #category : #copyrights }
HoneyGingerTestStream class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HoneyGingerTestStream >> contents [
	^ bytes copyFrom: 1 to: writeIndex - 1
]

{ #category : #'initialize-release' }
HoneyGingerTestStream >> initialize [
	super initialize.
	bytes := ByteArray new: 10.
	readIndex := 1.
	writeIndex := 1.
	readSemaphore := Semaphore new
]

{ #category : #accessing }
HoneyGingerTestStream >> next [
	readSemaphore wait.
	[ ^ bytes at: readIndex ] ensure: [ readIndex := readIndex + 1 ]
]

{ #category : #accessing }
HoneyGingerTestStream >> next: anInteger [
	| result |
	result := Array new: anInteger.
	1 to: anInteger do: [ :index | result at: index put: self next ].
	^ result
]

{ #category : #accessing }
HoneyGingerTestStream >> nextPut: anInteger [
	writeIndex > bytes size
		ifTrue: [ 
			| newBytes |
			newBytes := ByteArray new: bytes size * 2.
			newBytes writeStream nextPutAll: bytes.
			bytes := newBytes ].
	[ ^ bytes at: writeIndex put: anInteger ] ensure: [ writeIndex := writeIndex + 1. readSemaphore signal ]
]

{ #category : #accessing }
HoneyGingerTestStream >> nextPutAll: aCollection [
	aCollection do: [ :object | self nextPut: object ].
	^ aCollection
]

{ #category : #printing }
HoneyGingerTestStream >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	bytes printOn: aStream.
	aStream nextPut: $,.
	readIndex printOn: aStream.
	aStream nextPut: $,.
	writeIndex printOn: aStream.
	aStream nextPut: $)
]
