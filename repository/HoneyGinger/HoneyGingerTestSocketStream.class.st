Class {
	#name : #HoneyGingerTestSocketStream,
	#superclass : #Stream,
	#instVars : [
		'readStream',
		'writeStream'
	],
	#category : 'HoneyGinger-Communications-Tests'
}

{ #category : #copyrights }
HoneyGingerTestSocketStream class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HoneyGingerTestSocketStream class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #'instance creation' }
HoneyGingerTestSocketStream class >> readBuffer: aBuffer writeBuffer: anotherBuffer [
	^ (self basicNew)
		initialize;
		readBuffer: aBuffer writeBuffer: anotherBuffer;
		yourself
]

{ #category : #copyrights }
HoneyGingerTestSocketStream class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> binary [
	
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> close [
	readStream := nil.
	writeStream := nil
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> next [
	^ readStream next
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> next: anInteger [
	^ readStream next: anInteger
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> nextPut: anObject [
	^ writeStream nextPut: anObject 
]

{ #category : #accessing }
HoneyGingerTestSocketStream >> nextPutAll: aCollection [
	^ writeStream nextPutAll: aCollection
]

{ #category : #printing }
HoneyGingerTestSocketStream >> printOn: aStream [
	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	readStream printOn: aStream.
	aStream nextPut: $,.
	writeStream printOn: aStream.
	aStream nextPut: $)
]

{ #category : #private }
HoneyGingerTestSocketStream >> readBuffer: aBuffer writeBuffer: anotherBuffer [
	readStream := aBuffer.
	writeStream := anotherBuffer
]
