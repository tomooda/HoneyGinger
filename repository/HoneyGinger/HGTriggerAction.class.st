Class {
	#name : 'HGTriggerAction',
	#superclass : 'HGAction',
	#instVars : [
		'action',
		'conditionBlock',
		'oneShot',
		'loaded'
	],
	#category : 'HoneyGinger-Actions-Simulation',
	#package : 'HoneyGinger',
	#tag : 'Actions-Simulation'
}

{ #category : 'copyrights' }
HGTriggerAction class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGTriggerAction class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'copyrights' }
HGTriggerAction class >> showLicense [
	self LICENSE asText asMorph wrapFlag: true;
		 autoFit: false;
		 extent: 400 @ 400;
		 justified;
		 openInWindowLabeled: 'LICENSE'
]

{ #category : 'instance creation' }
HGTriggerAction class >> when: conditionBlock action: anHGAction [
	^ (self new)
		conditionBlock: conditionBlock;
		action: anHGAction;
		oneShot: true;
		yourself
]

{ #category : 'instance creation' }
HGTriggerAction class >> whenever: conditionBlock action: anHGAction [
	^ (self new)
		conditionBlock: conditionBlock;
		action: anHGAction;
		oneShot: false;
		yourself
]

{ #category : 'accessing' }
HGTriggerAction >> action [
	^ action
]

{ #category : 'accessing' }
HGTriggerAction >> action: anHGAction [
	action := anHGAction
]

{ #category : 'accessing' }
HGTriggerAction >> conditionBlock [
	^ conditionBlock 
]

{ #category : 'accessing' }
HGTriggerAction >> conditionBlock: aBlock [
	conditionBlock := aBlock
]

{ #category : 'simulating' }
HGTriggerAction >> effectIn: anHGSimulator deltaT: aNumber [
	(loaded = true and: conditionBlock)
		ifTrue: [ 
			action effectIn: anHGSimulator deltaT: aNumber.
			oneShot = true
				ifTrue: [ self unload ] ]
]

{ #category : 'initialize-release' }
HGTriggerAction >> initialize [
	self load
]

{ #category : 'accessing' }
HGTriggerAction >> load [
	self loaded: true
]

{ #category : 'accessing' }
HGTriggerAction >> loaded [
	^ loaded
]

{ #category : 'accessing' }
HGTriggerAction >> loaded: aBoolean [
	loaded := aBoolean = true
]

{ #category : 'accessing' }
HGTriggerAction >> oneShot [
	^ oneShot 
]

{ #category : 'accessing' }
HGTriggerAction >> oneShot: aBoolean [
	oneShot := aBoolean
]

{ #category : 'accessing' }
HGTriggerAction >> unload [
	self loaded: false
]
