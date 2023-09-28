Class {
	#name : 'HGImageClipper',
	#superclass : 'Morph',
	#instVars : [
		'basedir',
		'filenameIndex',
		'breadMorphs',
		'fileListMorph',
		'sourceImageMorph',
		'clippedImageMorph'
	],
	#category : 'HoneyGinger-Utilities',
	#package : 'HoneyGinger',
	#tag : 'Utilities'
}

{ #category : 'copyrights' }
HGImageClipper class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGImageClipper class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'accessing' }
HGImageClipper >> basedir: aFileDirectory [
	basedir := aFileDirectory.
	self updateBreadsMorphs.
	self changed: #filenames
]

{ #category : 'updating' }
HGImageClipper >> breadsDirectoriesFor: aFileDirectory [
	| components dir parent |
	components := OrderedCollection with: aFileDirectory.
	dir := aFileDirectory.
	parent := dir containingDirectory.
	[parent = dir] whileFalse: [
		dir := parent.
		components add: dir.
		parent := dir containingDirectory].
	^ components reversed
]

{ #category : 'updating' }
HGImageClipper >> fileChanged: aString [

]

{ #category : 'accessing' }
HGImageClipper >> filename [
	^ [self filenames at: filenameIndex] ifError: []
]

{ #category : 'accessing' }
HGImageClipper >> filenameIndex [
	^ filenameIndex
]

{ #category : 'accessing' }
HGImageClipper >> filenameIndex: anInteger [
	filenameIndex := anInteger.
	self updateSourceImage.
	self changed: #filenameIndex.
	self changed: #filename
]

{ #category : 'updating' }
HGImageClipper >> filenames [
	^ basedir entries collect: [:e | e name]
]

{ #category : 'updating' }
HGImageClipper >> flushSourceImage [
	sourceImageMorph image: (Form extent: 64 @ 64 depth: 32)
]

{ #category : 'initialize-release' }
HGImageClipper >> initialize [
	super initialize.
	filenameIndex := 0.
	self layoutPolicy: ProportionalLayout new.
	basedir := FileDirectory default.
	breadMorphs := Morph new.
	breadMorphs color: Color white.
	breadMorphs
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight.
	self addMorph: breadMorphs fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 0) offsets: (0 @ 0 corner: 0 @ 24)).
	self updateBreadsMorphs.
	fileListMorph := PluggableListMorph
		on: self
		list: #filenames
		selected: #filenameIndex
		changeSelected: #filenameIndex:.
	self
		addMorph: fileListMorph
		fullFrame: (LayoutFrame fractions: (0 @ 0 corner: 1 @ 0.5) offsets: (0 @ 26 corner: 0 @ 0)).
	sourceImageMorph := (Form extent: 64 @ 64 depth: 32) asMorph.
	self addMorph: sourceImageMorph fullFrame: (LayoutFrame fractions: (0 @ 0.5 corner: 0.5 @ 1)).
	clippedImageMorph := (Form extent: 64 @ 64 depth: 32) asMorph.
	self addMorph: clippedImageMorph fullFrame: (LayoutFrame fractions: (0.5 @ 0.5 corner: 1 @ 1))
]

{ #category : 'updating' }
HGImageClipper >> newBreadFor: aFileDirectory [
	| buttonMorph |
	buttonMorph := PluggableButtonMorph on: self getState: nil action: nil.
	buttonMorph actionBlock:  [self basedir: aFileDirectory].
	^ buttonMorph
]

{ #category : 'updating' }
HGImageClipper >> updateBreadsMorphs [
	| dirs morphs |
	dirs := self breadsDirectoriesFor: basedir.
	morphs := breadMorphs submorphs copy.
	1 to: (dirs size min: morphs size) do: [ :index | 
		| dir |
		dir := dirs at: index.
		(morphs at: index) action: [self basedir: dir]].
	dirs size > morphs size
		ifTrue: [ morphs size + 1 to: dirs size do: [ :index | breadMorphs addMorph: (self newBreadFor: (dirs at: index)) ] ]
		ifFalse: [ dirs size + 1 to: morphs size do: [ :index | breadMorphs removeMorph: (morphs at: index)]]
]

{ #category : 'updating' }
HGImageClipper >> updateSourceImage [
	| name |
	name := self filename.
	name ifNil: [ ^ self flushSourceImage ].
	(name asLowercase endsWith: '.jpg')
		ifFalse: [ ^ self flushSourceImage ].
	(basedir isAFileNamed: self filename)
		ifFalse: [ ^ self flushSourceImage ].
	[ 
	| image |
	image := Form fromFileNamed: (basedir fullNameFor: name).
	image width > sourceImageMorph bounds width
		ifTrue: [ image := image magnifyBy: sourceImageMorph bounds width / image width ].
	image height > sourceImageMorph bounds height
		ifTrue: [ image := image magnifyBy: sourceImageMorph bounds height / image height ].
	sourceImageMorph image: image ] value
]
