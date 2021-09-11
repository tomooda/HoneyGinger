Class {
	#name : #HGStringVisualizer,
	#superclass : #HGVisualizer,
	#instVars : [
		'font',
		'color',
		'defaultString'
	],
	#category : #'HoneyGinger-Actions-UI'
}

{ #category : #'instance creation' }
HGStringVisualizer class >> color: aColor defaultString: aString [
	^ self font: TextStyle defaultFont color: aColor defaultString: aString
]

{ #category : #'instance creation' }
HGStringVisualizer class >> font: aFont color: aColor defaultString: aString [
	^ (self basicNew)
		font: aFont;
		color: aColor;
		defaultString: aString;
		yourself
]

{ #category : #accessing }
HGStringVisualizer >> color [
	^ color
]

{ #category : #accessing }
HGStringVisualizer >> color: anObject [
	color := anObject
]

{ #category : #accessing }
HGStringVisualizer >> defaultString [
	^ defaultString
]

{ #category : #accessing }
HGStringVisualizer >> defaultString: anObject [
	defaultString := anObject
]

{ #category : #drawing }
HGStringVisualizer >> draw: anHGSimulator on: aCanvas [

	| h |
	h := font height / 2.0.
	anHGSimulator particlesDo: [ :particle | 
		particle position ifNotNil: [ :p | 
			| string w |
			string := particle at: #string ifAbsent: [ defaultString ].
			w := (font widthOfString: string) / 2.0.
			aCanvas
				drawString: string
				at: p x - w @ (p y - h)
				font: font
				color: color ] ]
]

{ #category : #accessing }
HGStringVisualizer >> font [
	^ font
]

{ #category : #accessing }
HGStringVisualizer >> font: anObject [
	font := anObject
]
