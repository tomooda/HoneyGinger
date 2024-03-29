Class {
	#name : 'HGViscosityInitialization',
	#superclass : 'HGAction',
	#instVars : [
		'viscosity'
	],
	#category : 'HoneyGinger-Actions-Thermal',
	#package : 'HoneyGinger',
	#tag : 'Actions-Thermal'
}

{ #category : 'copyrights' }
HGViscosityInitialization class >> LICENSE [
	^ self MITLicense
]

{ #category : 'copyrights' }
HGViscosityInitialization class >> MITLicense [
	^ 'Copyright (c) 2011 Tomohiro Oda and Software Research Associates, Inc.\\Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\\The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software\\THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' withCRs
]

{ #category : 'instance creation' }
HGViscosityInitialization class >> with: aNumber [
	^ (self new)
		viscosity: aNumber;
		yourself
]

{ #category : 'simulating' }
HGViscosityInitialization >> effect: anHGParticle in: anHGSimulator deltaT: aNumber [
	anHGParticle viscosity: viscosity
]

{ #category : 'accessing' }
HGViscosityInitialization >> viscosity [
	^ viscosity
]

{ #category : 'accessing' }
HGViscosityInitialization >> viscosity: aNumber [
	viscosity := aNumber
]
