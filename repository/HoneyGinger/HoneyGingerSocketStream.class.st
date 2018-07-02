Class {
	#name : #HoneyGingerSocketStream,
	#superclass : #Object,
	#instVars : [
		'transportStream'
	],
	#category : 'HoneyGinger-Communications-Streams'
}

{ #category : #copyrights }
HoneyGingerSocketStream class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerSocketStream class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HoneyGingerSocketStream class >> on: aStream [
	^ (self basicNew)
		initialize;
		setStream: aStream;
		yourself
]

{ #category : #'instance creation' }
HoneyGingerSocketStream class >> onSocket: aSocket [
	^ self
		on:
			((SocketStream on: aSocket)
				binary;
				yourself)
]

{ #category : #copyrights }
HoneyGingerSocketStream class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HoneyGingerSocketStream >> close [
	transportStream close
]

{ #category : #'magic numbers' }
HoneyGingerSocketStream >> closeCommand [
	^ 0
]

{ #category : #'magic numbers' }
HoneyGingerSocketStream >> downloadCommand [
	^ 101
]

{ #category : #accessing }
HoneyGingerSocketStream >> flush [
	transportStream flush
]

{ #category : #accessing }
HoneyGingerSocketStream >> getDeserializer [
	^ HoneyGingerDeserializer on: transportStream
]

{ #category : #accessing }
HoneyGingerSocketStream >> getSerializer [
	^ HoneyGingerSerializer on: transportStream 
]

{ #category : #accessing }
HoneyGingerSocketStream >> next [
	^ transportStream next
]

{ #category : #accessing }
HoneyGingerSocketStream >> next: anInteger [
	^ transportStream next: anInteger 
]

{ #category : #accessing }
HoneyGingerSocketStream >> nextPut: byte [
	^ transportStream nextPut: byte
]

{ #category : #accessing }
HoneyGingerSocketStream >> nextPutAll: bytes [
	^ transportStream nextPutAll: bytes
]

{ #category : #private }
HoneyGingerSocketStream >> setStream: aStream [
	transportStream := aStream
]

{ #category : #'magic numbers' }
HoneyGingerSocketStream >> uploadCommand [
	^ 102
]
