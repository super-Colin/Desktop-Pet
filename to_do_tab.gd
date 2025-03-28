extends VBoxContainer


var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"
var todoRowScene = preload("res://to_do_row.tscn")


var makingList = false

const SAVE_SECTION = "todo_tab"

func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveTodoButton.pressed.connect(saveTodo)
	%NewListButton.pressed.connect(makingNewList)
	#
	if not todoLists.keys():
		return
	refreshListsList()
	refreshTodoList()

func makingNewList():
	makingList = true


func saveTodo():
	if makingList:
		saveNewList()
	else:
		saveNewTodo()

func saveNewList():
	print("todo - new list is: ", %TodoName.text)
	todoLists[%TodoName.text] = {}
	refreshListsList()
	swapActiveList(%TodoName.text)
	saveTodos()
	makingList = false

func saveNewTodo():
	print("todo - new todo is: ", %TodoName.text)
	todoLists[currentList][%TodoName.text] = false
	saveTodos()
	#refreshSnippetsList()
	#closeSnippetPad()
	refreshTodoList()

func saveTodos():
	Saver.saveGameSection(SAVE_SECTION, "todoLists", todoLists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)


func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	for key in todoLists.keys():
		var newButton = Button.new()
		newButton.text = key
		newButton.pressed.connect(swapActiveList.bind(key))
		%ListsList.add_child(newButton)

func swapActiveList(newList:String):
	currentList = newList
	refreshTodoList()

func refreshTodoList():
	for c in %TodosList.get_children():
		c.queue_free()
	for key in todoLists[currentList].keys():
		var newRow = todoRowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		%TodosList.add_child(newRow)
