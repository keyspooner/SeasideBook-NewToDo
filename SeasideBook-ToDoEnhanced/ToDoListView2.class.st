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
					with: [ (html tag: 'i') class: 'fa fa-trash'; with: [ html anchor callback: [self model remove: anItem]]].
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
html button callback: [Transcript cr; show: 'Button pressed']; with: 'Press'.
	html break.
	html text: self messageText asString
]

{ #category : #rendering }
ToDoListView2 >> style [ 
^ 'body {
	font-family: Roboto;
  background: -webkit-linear-gradient(90deg, #2BC0E4 10%, #EAECC6 90%); /* Chrome 10+, Saf5.1+ */
  background:    -moz-linear-gradient(90deg, #2BC0E4 10%, #EAECC6 90%); /* FF3.6+ */
  background:     -ms-linear-gradient(90deg, #2BC0E4 10%, #EAECC6 90%); /* IE10 */
  background:      -o-linear-gradient(90deg, #2BC0E4 10%, #EAECC6 90%); /* Opera 11.10+ */
  background:         linear-gradient(90deg, #2BC0E4 10%, #EAECC6 90%); /* W3C */
}

ul {
	list-style: none;
	margin: 0;
	padding: 0;
}


h1 {
	background: #2980b9;
	color: white;
	margin: 0;
	padding: 10px 20px;
	text-transform: uppercase;
	font-size: 24px;
	font-weight: normal;
}

.fa-plus {
	float: right;
}

li {
	background: #fff;
	height: 40px;
	line-height: 40px;
	color: #666;
}

li:nth-child(2n){
	background: #f7f7f7;
}

li span {
	background: #e74c3c;
	height: 40px;
	margin-right: 20px;
	text-align: center;
	color: white;
	width: 0;
	display: inline-block;
	transition: 0.2s linear;
	opacity: 0;
}

li:hover span {
	width: 40px;
	opacity: 1.0;
}

input {
	font-size: 18px;
	color: #2980b9;
	background-color: #f7f7f7;
	width: 100%;
	padding: 13px 13px 13px 20px;
	box-sizing: border-box;
	border: 3px solid rgba(0,0,0,0);
}

input:focus{
	background: #fff;
	border: 3px solid #2980b9;
	outline: none;
}

#container {
	width: 360px;
	margin: 100px auto;
	background: #f7f7f7;
	box-shadow: 0 0 3px rgba(0,0,0, 0.1);
}

.completed {
	color: gray;
	text-decoration: line-through;
}'
]

{ #category : #rendering }
ToDoListView2 >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	anHtmlRoot stylesheet url: 'https://fonts.googleapis.com/css?family=Roboto:400,700,500'.
	anHtmlRoot script defer url: 'https://use.fontawesome.com/releases/v5.0.6/js/all.js'
]
