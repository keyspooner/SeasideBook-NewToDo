Class {
	#name : #ToDoListView2,
	#superclass : #WAComponent,
	#instVars : [
		'messageText'
	],
	#category : #'SeasideBook-ToDoEnhanced'
}

{ #category : #'class initialization' }
ToDoListView2 class >> initialize [ 
	|application|
	"self initialize"
	application := WAAdmin register: self asApplicationAt: 'todo2'.
	application
		addLibrary: JQDevelopmentLibrary;
		addLibrary: JQUiDevelopmentLibrary
]

{ #category : #accessing }
ToDoListView2 >> messageText [
	^ messageText
]

{ #category : #accessing }
ToDoListView2 >> messageText: anObject [
	messageText := anObject
]

{ #category : #accessing }
ToDoListView2 >> model [ 
	^ ToDoList default
]

{ #category : #rendering }
ToDoListView2 >> renderContentOn2: html [
	html heading level: 1; with: 'To-do List'.
	html textInput
		attributeAt: 'placeholder' put: 'Add New Todo';
       onKeyPress:
            (html jQuery ajax
                callback: [ :inputValue | messageText := inputValue]
                value: (JSStream on: 'event.which'));
		 onKeyPress:
            (html jQuery ajax
                callback: [ :inputValue | 
"							self halt. "
							Transcript cr; show: inputValue.
							(messageText = '13')
								ifTrue: [ 
									Transcript cr; show: 'Enter was clicked'.
							 html javascript alert: 'hello'.
									 ]
							]
                value: (html jQuery this value)).
		html unorderedList: [ self renderItemsOn: html ]
]

{ #category : #rendering }
ToDoListView2 >> renderContentOn3: html [
    html heading: self model title.
    html unorderedList: [ self renderItemsOn: html ]
]

{ #category : #rendering }
ToDoListView2 >> renderContentOn: html [
	html div
		id: 'container';
		with: [ html heading
				level: 1;
				with: [ html text: 'To-do List'.
					html span
						id: 'toggle-form';
						with: [ (html
								tag: 'i')
								class: 'fa fa-plus' ] ].
			html
				form: [ html textInput
						attributeAt: 'placeholder' put: 'Add New Todo';
						callback: [ :inputValue | 
							self model
								add:
									(ToDoItem new
										title: inputValue;
										due: '12/15/2019' asDate;
										done: false) ].
					html unorderedList: [ self renderItemsOn: html ] ] ]
]

{ #category : #rendering }
ToDoListView2 >> renderContentOnAjax: html [
	html heading level: 1; with: 'To-do List'.
	html form: [ 
	html textInput
		attributeAt: 'placeholder' put: 'Add New Todo';
       onKeyPress:
            (html jQuery ajax
                callback: [ :inputValue | messageText := inputValue]
                value: (JSStream on: 'event.which'));
		 onKeyPress:
            (html jQuery ajax
                callback: [ :inputValue | 
"							self halt. "
							Transcript cr; show: inputValue.
							(messageText = '13')
								ifTrue: [ 
									Transcript cr; show: 'Enter was clicked'.
							 		self model add: (ToDoItem new 
			title: inputValue;
			due: '12/15/2019' asDate;
			done: false)
									 ]
							]
                value: (html jQuery this value))].
		html unorderedList: [ self renderItemsOn: html ]
]

{ #category : #rendering }
ToDoListView2 >> renderItem: anItem on: html [
    (html listItem)
    	 "with: [ html span: [ html text: 'X']  anItem title]"
		with: [
				(html span)  
					"onClick: (html jQuery this parent) remove; "
					"with: [ (html tag: 'i') class: 'fa fa-tash'; with: 'X ' ]."
					with: [ (html tag: 'i') class: 'fa fa-tash'; with: [ html anchor callback: [self model remove: anItem]; with: 'X ']].
					"with: [ html anchor callback: [self model remove: anItem]; with: 'X ']."
				html text: anItem title].
]

{ #category : #rendering }
ToDoListView2 >> renderItemsOn: html [
    self model items
        do: [ :each | self renderItem: each on: html ]
]

{ #category : #rendering }
ToDoListView2 >> renderMessageTextAndButtonOn: html [
self halt.
html button callback: [Transcript cr; show: 'Button pressed']; with: 'Press'.
	html break.
	html text: self messageText asString
]
