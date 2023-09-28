Class {
	#name : 'HoneyGingerTestStreamTest',
	#superclass : 'TestCase',
	#instVars : [
		'buffer'
	],
	#category : 'HoneyGinger-Communications-Tests',
	#package : 'HoneyGinger',
	#tag : 'Communications-Tests'
}

{ #category : 'copyrights' }
HoneyGingerTestStreamTest class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HoneyGingerTestStreamTest class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HoneyGingerTestStreamTest class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'setups' }
HoneyGingerTestStreamTest >> setUp [
	buffer := HoneyGingerTestStream new
]

{ #category : 'tests' }
HoneyGingerTestStreamTest >> testContents [
	0 to: 255 do: [ :byte | buffer nextPut: byte ].
	self assert: (buffer contents hasEqualElements: (0 to: 255) asByteArray)
]

{ #category : 'tests' }
HoneyGingerTestStreamTest >> testNextN [
	0 to: 255 do: [ :byte | buffer nextPut: byte ].
	0 to: 200 by: 10 do: [ :base | self assert: ((0 to: 9) collect: [ :digit | base + digit ]) asArray equals: (buffer next: 10) ]
]

{ #category : 'tests' }
HoneyGingerTestStreamTest >> testNextPut1 [
	0 to: 255 do: [ :byte | buffer nextPut: byte ].
	0 to: 255 do: [ :byte | self assert: byte equals: buffer next ]
]

{ #category : 'tests' }
HoneyGingerTestStreamTest >> testNextPut2 [
	0 to: 255 do: [ :byte | 
		buffer nextPut: byte.
		self assert: byte equals: buffer next ]
]

{ #category : 'tests' }
HoneyGingerTestStreamTest >> testNextPutAll [
	buffer nextPutAll: (0 to: 255) asByteArray.
	0 to: 255 do: [ :byte | self assert: byte equals: buffer next ]
]
