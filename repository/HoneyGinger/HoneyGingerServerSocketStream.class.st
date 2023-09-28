Class {
	#name : 'HoneyGingerServerSocketStream',
	#superclass : 'HoneyGingerSocketStream',
	#instVars : [
		'clientID',
		'clientIDBlock',
		'downloadBlock',
		'uploadBlock'
	],
	#category : 'HoneyGinger-Communications-Streams',
	#package : 'HoneyGinger',
	#tag : 'Communications-Streams'
}

{ #category : 'copyrights' }
HoneyGingerServerSocketStream class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerServerSocketStream class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerServerSocketStream class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HoneyGingerServerSocketStream >> clientID [
	^ clientID
]

{ #category : 'accessing' }
HoneyGingerServerSocketStream >> clientIDBlock [
	^ clientIDBlock
]

{ #category : 'accessing' }
HoneyGingerServerSocketStream >> clientIDBlock: aBlock [
	clientIDBlock := aBlock
]

{ #category : 'defaults' }
HoneyGingerServerSocketStream >> defaultClientIDBlock [
	"By default, say you are unidentified."

	^ [ :id | id ]
]

{ #category : 'defaults' }
HoneyGingerServerSocketStream >> defaultDownloadBlock [
	"By default, send empty data."

	^ [ :client | Dictionary new ]
]

{ #category : 'defaults' }
HoneyGingerServerSocketStream >> defaultUploadBlock [
	"The default do nothing. Just throws the data away."

	^ [ :client :key :value |  ]
]

{ #category : 'sessions' }
HoneyGingerServerSocketStream >> download [
	| objects serializer |
	objects := downloadBlock value: clientID.
	serializer := self getSerializer.
	objects
		keysAndValuesDo: [ :key :value | 
			serializer writeObject: key.
			transportStream nextPutAll: value ].
	serializer writeEnd.
	self flush.
	^ objects
]

{ #category : 'accessing' }
HoneyGingerServerSocketStream >> downloadBlock: aBlock [
	downloadBlock := aBlock
]

{ #category : 'sessions' }
HoneyGingerServerSocketStream >> endSession [
	self close
]

{ #category : 'initialize-release' }
HoneyGingerServerSocketStream >> initialize [
	super initialize.
	self clientIDBlock: self defaultClientIDBlock
]

{ #category : 'sessions' }
HoneyGingerServerSocketStream >> startSession [
	clientID := clientIDBlock value: self getDeserializer readObject.
	self getSerializer writeObject: clientID.
	self flush
]

{ #category : 'sessions' }
HoneyGingerServerSocketStream >> upload [
	self getDeserializer scanDo: [ :key :bytes | uploadBlock value: clientID value: key value: bytes ]
]

{ #category : 'accessing' }
HoneyGingerServerSocketStream >> uploadBlock: aBlock [
	uploadBlock := aBlock
]
