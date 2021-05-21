"
A dialog to show a message and a progress bar.
"
Class {
	#name : #SpProgressDialog,
	#superclass : #SpDialogPresenter,
	#instVars : [
		'title',
		'label',
		'progressBar',
		'maxValue'
	],
	#category : #'Spec2-Dialogs'
}

{ #category : #documentation }
SpProgressDialog class >> documentFactoryMethodSelector [
	
	^ #newProgress
]

{ #category : #example }
SpProgressDialog class >> example [

	self new
		title: 'Example Progress';
		label: 'You are seeing a progress dialog!';
		progressPercent: 30;
		openDialogWithSpec
]

{ #category : #example }
SpProgressDialog class >> exampleInformUserDuring [

	self new
		title: 'Example Progress';
		informUserDuring: [ :bar | 
			1 to: 10 do: [ :index | 
				bar 
					label: ('Step {1}...' format: { index });
					progressPercent: index * 10.
				1 second wait ] ]
]

{ #category : #example }
SpProgressDialog class >> exampleModal [

	self new
		title: 'Example Progress';
		label: 'You are seeing a progress dialog!';
		progressPercent: 30;
		openModalWithSpec
]

{ #category : #accessing }
SpProgressDialog class >> extent [

	^ 600@100
]

{ #category : #api }
SpProgressDialog >> informUser: aString during: aBlock [ 

	self informUserDuring: [ :bar | 
		bar label: aString. 
		aBlock value ]
]

{ #category : #api }
SpProgressDialog >> informUserDuring: aBlock [
	| sem |

	sem := Semaphore new.
	[ 
		sem signal.
		aBlock value: self.
		self window close 
	] fork.
	
	sem wait.
	self openModalWithSpec
]

{ #category : #initialization }
SpProgressDialog >> initialize [

	super initialize.
	self title: 'Progress'.
	maxValue := 1.0
]

{ #category : #initialization }
SpProgressDialog >> initializeDialogWindow: aDialogWindowPresenter [
	
	self parentWindow 
		ifNotNil: [ :w | aDialogWindowPresenter centeredRelativeTo: w ] 
		ifNil: [ aDialogWindowPresenter centered ]
]

{ #category : #initialization }
SpProgressDialog >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		borderWidth: 5;
		spacing: 5;
		add: (label := self newLabel) expand: false;
		add: (progressBar := self newProgressBar) expand: false;
		yourself)
]

{ #category : #initialization }
SpProgressDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self title;
		initialExtent: self class extent
]

{ #category : #api }
SpProgressDialog >> label [

	^ label label
]

{ #category : #api }
SpProgressDialog >> label: aString [

	label label: aString
]

{ #category : #api }
SpProgressDialog >> max: aNumber [
	"sets the maximum value. 
	 Affects how #value: is calculated"

	maxValue := aNumber
]

{ #category : #api }
SpProgressDialog >> progress: aFraction [

	progressBar fixedAt: aFraction
]

{ #category : #api }
SpProgressDialog >> progressPercent: aNumber [

	progressBar fixedPercentage: aNumber
]

{ #category : #api }
SpProgressDialog >> title [

	^ title
]

{ #category : #api }
SpProgressDialog >> title: aString [

	title := aString
]

{ #category : #api }
SpProgressDialog >> value: aFraction [

	self progress: (aFraction / maxValue) asFloat
]