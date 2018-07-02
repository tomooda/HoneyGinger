Class {
	#name : #HGTriggerBlockAction,
	#superclass : #HGAction,
	#instVars : [
		'actionBlock',
		'conditionBlock',
		'oneShot',
		'loaded'
	],
	#category : 'HoneyGinger-Actions-Simulation'
}

{ #category : #copyrights }
HGTriggerBlockAction class >> LICENSE [
	^ self MITLicense
]

{ #category : #copyrights }
HGTriggerBlockAction class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : #copyrights }
HGTriggerBlockAction class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : #'instance creation' }
HGTriggerBlockAction class >> when: conditionBlock do: aBlock [
	^ (self new)
		conditionBlock: conditionBlock;
		actionBlock: aBlock;
		oneShot: true;
		load;
		yourself
]

{ #category : #'instance creation' }
HGTriggerBlockAction class >> whenever: conditionBlock do: aBlock [
	^ (self new)
		conditionBlock: conditionBlock;
		actionBlock: aBlock;
		oneShot: false;
		load;
		yourself
]

{ #category : #accessing }
HGTriggerBlockAction >> actionBlock [
	^ actionBlock
]

{ #category : #accessing }
HGTriggerBlockAction >> actionBlock: aBlock [
	actionBlock := aBlock
]

{ #category : #accessing }
HGTriggerBlockAction >> conditionBlock [
	^ conditionBlock 
]

{ #category : #accessing }
HGTriggerBlockAction >> conditionBlock: aBlock [
	conditionBlock := aBlock
]

{ #category : #simulating }
HGTriggerBlockAction >> effectIn: anHGSimulator deltaT: aNumber [
	(loaded = true and: conditionBlock)
		ifTrue: [ 
			actionBlock value.
			oneShot = true
				ifTrue: [ self unload ] ]
]

{ #category : #accessing }
HGTriggerBlockAction >> load [
	self loaded: true
]

{ #category : #accessing }
HGTriggerBlockAction >> loaded [
	^ loaded
]

{ #category : #accessing }
HGTriggerBlockAction >> loaded: aBoolean [
	loaded := aBoolean = true
]

{ #category : #accessing }
HGTriggerBlockAction >> oneShot [
	^ oneShot 
]

{ #category : #accessing }
HGTriggerBlockAction >> oneShot: aBoolean [
	oneShot := aBoolean
]

{ #category : #accessing }
HGTriggerBlockAction >> unload [
	self loaded: false
]
