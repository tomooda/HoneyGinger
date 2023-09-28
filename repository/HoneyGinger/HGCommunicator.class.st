Class {
	#name : 'HGCommunicator',
	#superclass : 'HGAction',
	#instVars : [
		'address',
		'port',
		'honeyGingerClientStream'
	],
	#category : 'HoneyGinger-Actions-Networking',
	#package : 'HoneyGinger',
	#tag : 'Actions-Networking'
}

{ #category : 'copyrights' }
HGCommunicator class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGCommunicator class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGCommunicator class >> address: aByteArray port: anInteger [
	^ (self new)
		setAddress: aByteArray port: anInteger;
		yourself
]

{ #category : 'copyrights' }
HGCommunicator class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HGCommunicator >> getStream [
	^ honeyGingerClientStream
		ifNil: [ 
			| socket |
			socket := Socket newTCP.
			socket connectTo: address port: port.
			honeyGingerClientStream := (HoneyGingerClientSocketStream onSocket: socket)
				startSession;
				yourself ]
]

{ #category : 'private' }
HGCommunicator >> setAddress: aByteArray port: anInteger [
	address := aByteArray.
	port := anInteger
]
