Class {
	#name : 'HoneyGingerTestSocketStreamTest',
	#superclass : 'TestCase',
	#instVars : [
		'serverStream',
		'clientStream'
	],
	#category : 'HoneyGinger-Communications-Tests',
	#package : 'HoneyGinger',
	#tag : 'Communications-Tests'
}

{ #category : 'copyrights' }
HoneyGingerTestSocketStreamTest class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerTestSocketStreamTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerTestSocketStreamTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'setup' }
HoneyGingerTestSocketStreamTest >> setUp [
	| connection |
	connection := HoneyGingerTestConnection new.
	serverStream := connection serverStream.
	clientStream := connection clientStream
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testClientNextPutAllServerNext [
	clientStream nextPutAll: #(4 4 1).
	self assert: 4 equals: serverStream next.
	self assert: 4 equals: serverStream next.
	self assert: 1 equals: serverStream next
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testClientNextPutClientNext [
	clientStream nextPut: 1.
	self assert: 1 equals: serverStream next
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testClientNextPutServerNext2 [
	clientStream nextPut: 4.
	clientStream nextPut: 4.
	clientStream nextPut: 1.
	self assert: #(4 4) equals: (serverStream next: 2).
	self assert: 1 equals: serverStream next
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testServerNextPutAllClientNext [
	serverStream nextPutAll: #(4 4 1).
	self assert: 4 equals: clientStream next.
	self assert: 4 equals: clientStream next.
	self assert: 1 equals: clientStream next
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testServerNextPutClientNext [
	serverStream nextPut: 1.
	self assert: 1 equals: clientStream next
]

{ #category : 'tests' }
HoneyGingerTestSocketStreamTest >> testServerNextPutClientNext2 [
	serverStream nextPut: 4.
	serverStream nextPut: 4.
	serverStream nextPut: 1.
	self assert: #(4 4) equals: (clientStream next: 2).
	self assert: 1 equals: clientStream next
]
