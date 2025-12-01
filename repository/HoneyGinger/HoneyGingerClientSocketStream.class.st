Class {
	#name : 'HoneyGingerClientSocketStream',
	#superclass : 'HoneyGingerSocketStream',
	#instVars : [
		'clientID'
	],
	#category : 'HoneyGinger-Communications-Streams',
	#package : 'HoneyGinger',
	#tag : 'Communications-Streams'
}

{ #category : 'copyrights' }
HoneyGingerClientSocketStream class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerClientSocketStream class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerClientSocketStream class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HoneyGingerClientSocketStream >> clientID [
	^ clientID
]

{ #category : 'accessing' }
HoneyGingerClientSocketStream >> clientID: anInteger [
	clientID := anInteger
]

{ #category : 'sessions' }
HoneyGingerClientSocketStream >> download [
	| objects size |
	transportStream nextPut: self downloadCommand.
	self flush.
	^ self getDeserializer read
]

{ #category : 'sessions' }
HoneyGingerClientSocketStream >> downloadDo: aBlock [
	transportStream nextPut: self downloadCommand.
	self flush.
	self getDeserializer readDo: aBlock
]

{ #category : 'sessions' }
HoneyGingerClientSocketStream >> endSession [
	transportStream nextPut: self closeCommand.
	self flush.
	self close
]

{ #category : 'accessing' }
HoneyGingerClientSocketStream >> getDeserializer [
	^ HoneyGingerDeserializer on: self
]

{ #category : 'accessing' }
HoneyGingerClientSocketStream >> getSerializer [
	^ HoneyGingerSerializer on: self
]

{ #category : 'sessions' }
HoneyGingerClientSocketStream >> startSession [
	self getSerializer writeObject: (clientID ifNil: [0]).
	self flush.
	clientID := self getDeserializer readObject
]

{ #category : 'sessions' }
HoneyGingerClientSocketStream >> upload: aDictionary [
	transportStream nextPut: self uploadCommand.
	self getSerializer write: aDictionary.
	self flush
]
