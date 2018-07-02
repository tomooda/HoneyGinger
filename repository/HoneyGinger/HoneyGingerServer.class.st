Class {
	#name : #HoneyGingerServer,
	#superclass : #Object,
	#instVars : [
		'socket',
		'data',
		'locks',
		'clientIDs',
		'acceptingProcess'
	],
	#category : 'HoneyGinger-Communications-Server'
}

{ #category : #copyrights }
HoneyGingerServer class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerServer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HoneyGingerServer class >> on: aListeningSocket [
	^ (self new)
		setSocket: aListeningSocket;
		yourself
]

{ #category : #'instance creation' }
HoneyGingerServer class >> port: aNumber [
	| socket |
	socket := Socket tcpCreateIfFail: [ self error: 'Can''t create a socket' ].
	socket listenOn: aNumber backlogSize: 10.
	^ self on: socket
]

{ #category : #copyrights }
HoneyGingerServer class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HoneyGingerServer >> clientIDFor: anInteger [
	| id |
	id := self privateClientIDFor: anInteger.
	clientIDs at: id put: TimeStamp now.
	self garbageCollectClientIDs.
	^ id
]

{ #category : #defaults }
HoneyGingerServer >> defaultMaxIdleTimeForClient [
	^ Duration seconds: 60
]

{ #category : #private }
HoneyGingerServer >> garbageCollectClientIDs [
	| deadline deadClientIDs |
	deadline := TimeStamp now + maxIdleTimeForClient negated.
	deadClientIDs := Array new writeStream.
	clientIDs
		keysAndValuesDo: [ :clientID :timestamp | 
			timestamp < deadline
				ifTrue: [ deadClientIDs nextPut: clientID ] ].
	deadClientIDs contents do: [ :clientID | clientIDs removeKey: clientID ifAbsent: [  ] ]
]

{ #category : #'initialize-release' }
HoneyGingerServer >> initialize [
	super initialize.
	data := Dictionary new: 800.
	locks := Dictionary new: 10.
	clientIDs := Dictionary new: 10.
	maxIdleTimeForClient := self defaultMaxIdleTimeForClient
]

{ #category : #accessing }
HoneyGingerServer >> maxIdleTimeForClient [
	^ maxIdleTimeForClient 
]

{ #category : #accessing }
HoneyGingerServer >> maxIdleTimeForClient: aDuration [
	maxIdleTimeForClient := aDuration
]

{ #category : #accessing }
HoneyGingerServer >> particleAt: anInteger put: anObject [
	^ (locks includesKey: anInteger)
		ifFalse: [ data at: anInteger put: anObject ]
]

{ #category : #accessing }
HoneyGingerServer >> particleData [
	^data
]

{ #category : #private }
HoneyGingerServer >> privateClientIDFor: anInteger [
	^ (clientIDs includesKey: anInteger)
		ifTrue: [ anInteger ]
		ifFalse: [ 
			| clientID |
			clientID := clientIDs size + 1.
			(clientIDs includesKey: clientID)
				ifTrue: [ clientID ]
				ifFalse: [ 
					clientID := 1.
					[ clientIDs includesKey: clientID ] whileTrue: [ clientID := clientID + 1 ] ].
			clientID ]
]

{ #category : #accessing }
HoneyGingerServer >> refreshClientID: anInteger [
	clientIDs at: anInteger put: TimeStamp now.
	self garbageCollectClientIDs
]

{ #category : #accessing }
HoneyGingerServer >> releaseClientID: anInteger [
	clientIDs removeKey: anInteger ifAbsent: [  ].
	self garbageCollectClientIDs
]

{ #category : #servicing }
HoneyGingerServer >> serveFor: aSocket [
	[ 
	(HoneyGingerServerWorker
		server: self
		transportStream:
			((SocketStream on: aSocket)
				binary;
				yourself)) process ] fork
]

{ #category : #private }
HoneyGingerServer >> setSocket: aSocket [
	socket := aSocket
]

{ #category : #servicing }
HoneyGingerServer >> shutdown [
	acceptingProcess
		ifNotNil: [ 
			acceptingProcess terminate.
			acceptingProcess := nil ].
	socket
		ifNotNil: [ 
			socket closeAndDestroy.
			socket := nil ]
]

{ #category : #servicing }
HoneyGingerServer >> startup [
	acceptingProcess := [ 
	[ [ (socket waitForAcceptFor: Socket standardTimeout) ifNotNilDo: [ :serverSocket | self serveFor: serverSocket ] ] repeat ]
		ifError: [ socket close ] ] fork
]
