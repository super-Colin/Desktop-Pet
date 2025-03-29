extends VBoxContainer


var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"
var todoRowScene = preload("res://tabs/to_do_row.tscn")


var makingList = false

const SAVE_SECTION = "todo_tab"

func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveTodoButton.pressed.connect(saveTodo)
	%NewListButton.pressed.connect(makingNewList)
	%TodoName.text_submitted.connect(_textSubmitted)
	#
	if not todoLists.keys():
		return
	refreshListsList()
	refreshTodoList()


func _textSubmitted(newText):
	saveTodo()



func makingNewList():
	makingList = true


func saveTodo():
	if makingList:
		saveNewList()
	else:
		saveNewTodo()

func saveNewList():
	#print("todo - new list is: ", %TodoName.text)
	todoLists[%TodoName.text] = {}
	refreshListsList()
	swapActiveList(%TodoName.text)
	clearInputBar()
	makingList = false
	saveTodos()
	%TodoName.text = ""
	%TodoName.grab_focus()

func saveNewTodo():
	#print("todo - new todo is: ", %TodoName.text)
	todoLists[currentList][%TodoName.text] = false
	clearInputBar()
	refreshTodoList()
	saveTodos()
	%TodoName.text = ""

func saveTodos():
	Saver.saveGameSection(SAVE_SECTION, "todoLists", todoLists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)
	#print("todo - saved")

func clearInputBar():
	%TodoName.text = ""

func swapActiveList(newList:String):
	currentList = newList
	refreshTodoList()
	saveTodos()

func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	for key in todoLists.keys():
		var newButton = Button.new()
		newButton.text = key
		newButton.pressed.connect(swapActiveList.bind(key))
		%ListsList.add_child(newButton)

# ui_text_accept

func refreshTodoList():
	#print("todo - ", todoLists[currentList])
	for c in %TodosList.get_children():
		c.queue_free()
	for key in todoLists[currentList].keys():
		var newRow = todoRowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		newRow.todoToggled.connect(todoToggled)
		newRow.deleteRequested.connect(deleteTodo)
		%TodosList.add_child(newRow)

func deleteTodo(todoName):
	todoLists[currentList].erase(todoName)
	refreshTodoList()

func todoToggled(name:String, isCompleted:bool):
	todoLists[currentList][name] = isCompleted
	print("todo - todo toggled: ", name, ", ", isCompleted, ", list: ", todoLists[currentList])
	saveTodos()
