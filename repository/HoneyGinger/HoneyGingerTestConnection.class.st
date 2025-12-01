Class {
	#name : 'HoneyGingerTestConnection',
	#superclass : 'Object',
	#instVars : [
		'serverSocket',
		'clientSocket',
		'csStream',
		'scStream'
	],
	#category : 'HoneyGinger-Communications-Tests',
	#package : 'HoneyGinger',
	#tag : 'Communications-Tests'
}

{ #category : 'copyrights' }
HoneyGingerTestConnection class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerTestConnection class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerTestConnection class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'accessing' }
HoneyGingerTestConnection >> clientStream [
	^ clientSocket
		ifNotNil: [ :socket | 
			clientSocket := nil.
			socket ]
		ifNil: [ self error: 'Can''t listen to the same port more than once.' ]
]

{ #category : 'initialie-release' }
HoneyGingerTestConnection >> initialize [
	csStream := HoneyGingerTestStream new.
	scStream := HoneyGingerTestStream new.
	serverSocket := HoneyGingerTestSocketStream readBuffer: csStream writeBuffer: scStream.
	clientSocket := HoneyGingerTestSocketStream readBuffer: scStream writeBuffer: csStream
]

{ #category : 'accessing' }
HoneyGingerTestConnection >> serverStream [
	^ serverSocket
		ifNotNil: [ :socket | 
			serverSocket := nil.
			socket ]
		ifNil: [ self error: 'Can''t listen to the same port more than once.' ]
]
