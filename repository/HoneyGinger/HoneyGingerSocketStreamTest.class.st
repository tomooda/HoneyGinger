Class {
	#name : #HoneyGingerSocketStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'serverStream',
		'clientStream'
	],
	#category : 'HoneyGinger-Communications-Tests'
}

{ #category : #copyrights }
HoneyGingerSocketStreamTest class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerSocketStreamTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HoneyGingerSocketStreamTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #private }
HoneyGingerSocketStreamTest >> deserialize: aByteArray [
	^ (HoneyGingerDeserializer on: aByteArray readStream) next
]

{ #category : #private }
HoneyGingerSocketStreamTest >> fork: aBlock and: anotherBlock [
	| semaphore results |
	results := Array new: 2.
	semaphore := Semaphore new.
	[ 
	results at: 1 put: aBlock value.
	semaphore signal ] fork.
	[ 
	results at: 2 put: anotherBlock value.
	semaphore signal ] fork.
	semaphore wait.
	semaphore wait
]

{ #category : #private }
HoneyGingerSocketStreamTest >> serialize: anObject [
	| stream |
	stream := ByteArray new writeStream.
	(HoneyGingerSerializer on: stream) nextPut: anObject.
	^ stream contents
]

{ #category : #running }
HoneyGingerSocketStreamTest >> setUp [
	| connection |
	connection := HoneyGingerTestConnection new.
	serverStream := HoneyGingerServerSocketStream on: connection serverStream.
	clientStream := HoneyGingerClientSocketStream on: connection clientStream
]

{ #category : #running }
HoneyGingerSocketStreamTest >> tearDown [
	serverStream ifNotNil: [ serverStream close ].
	clientStream ifNotNil: [ clientStream close ]
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testClientID [
	| clientID |
	clientID := 441.
	clientStream clientID: clientID.
	self fork: [ serverStream startSession ] and: [ clientStream startSession ].
	self assert: clientID equals: serverStream clientID.
	self assert: clientID equals: clientStream clientID
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testClientIDBlock [
	| clientIDBlock |
	clientIDBlock := [ :id | 441 ].
	serverStream clientIDBlock: clientIDBlock.
	self assert: clientIDBlock equals: serverStream clientIDBlock.
	self fork: [ serverStream startSession ] and: [ clientStream startSession ].
	self assert: 441 equals: serverStream clientID.
	self assert: 441 equals: clientStream clientID
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testDownload [
	| testdata |
	testdata := Dictionary new.
	testdata at: 38 put: 441.
	testdata at: 39 put: 392.
	self
		fork: [ 
			serverStream startSession.
			self assert: serverStream downloadCommand equals: serverStream next.
			serverStream
				downloadBlock: [ :id | 
					| serializedTestdata |
					serializedTestdata := Dictionary new.
					testdata keysAndValuesDo: [ :key :value | serializedTestdata at: key put: (self serialize: value) ].
					serializedTestdata ].
			serverStream download ]
		and: [ 
			| receivedData |
			clientStream startSession.
			receivedData := clientStream download.
			self assert: testdata equals: receivedData ]
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testDownloadDo [
	| testdata |
	testdata := Dictionary new.
	testdata at: 38 put: 441.
	testdata at: 39 put: 392.
	self
		fork: [ 
			serverStream startSession.
			self assert: serverStream downloadCommand equals: serverStream next.
			serverStream
				downloadBlock: [ :id | 
					| serializedTestdata |
					serializedTestdata := Dictionary new.
					testdata keysAndValuesDo: [ :key :value | serializedTestdata at: key put: (self serialize: value) ].
					serializedTestdata ].
			serverStream download ]
		and: [ 
			| receivedData |
			clientStream startSession.
			receivedData := Dictionary new.
			clientStream downloadDo: [ :key :value | receivedData at: key put: value ].
			self assert: testdata equals: receivedData ]
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testStartSession [
	self fork: [ serverStream startSession ] and: [ clientStream startSession ].
	self assert: serverStream clientID notNil.
	self assert: clientStream clientID notNil.
	self assert: serverStream clientID equals: clientStream clientID
]

{ #category : #tests }
HoneyGingerSocketStreamTest >> testUpload [
	| testdata |
	testdata := Dictionary new.
	testdata at: 38 put: 441.
	testdata at: 39 put: 392.
	self
		fork: [ 
			| receivedData |
			receivedData := Dictionary new.
			serverStream uploadBlock: [ :id :key :bytes | receivedData at: key put: (self deserialize: bytes) ].
			serverStream startSession.
			self assert: serverStream uploadCommand equals: serverStream next.
			serverStream upload.
			self assert: testdata equals: receivedData ]
		and: [ 
			clientStream startSession.
			clientStream upload: testdata ]
]
