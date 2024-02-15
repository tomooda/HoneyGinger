Class {
	#name : 'HGBackgroundImageVisualizer',
	#superclass : 'HGVisualizer',
	#instVars : [
		'form',
		'offset'
	],
	#category : 'HoneyGinger-Actions-UI',
	#package : 'HoneyGinger',
	#tag : 'Actions-UI'
}

{ #category : 'copyrights' }
HGBackgroundImageVisualizer class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGBackgroundImageVisualizer class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGBackgroundImageVisualizer class >> form: aForm [
	^ self form: aForm offset: 0@0
]

{ #category : 'instance creation' }
HGBackgroundImageVisualizer class >> form: aForm offset: aPoint [
	^ (self new)
		form: aForm;
		offset: aPoint;
		yourself
]

{ #category : 'drawing' }
HGBackgroundImageVisualizer >> draw: anHGSimulator on: aCanvas [
	aCanvas drawImage: form at: 0@0 sourceRect: (offset extent: anHGSimulator extent)
]

{ #category : 'accessing' }
HGBackgroundImageVisualizer >> form [
	^ form
]

{ #category : 'accessing' }
HGBackgroundImageVisualizer >> form: aForm [
	form := aForm
]

{ #category : 'accessing' }
HGBackgroundImageVisualizer >> offset [
	^ offset
]

{ #category : 'accessing' }
HGBackgroundImageVisualizer >> offset: aPoint [
	offset := aPoint asPoint
]
