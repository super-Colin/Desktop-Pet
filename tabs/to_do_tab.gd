extends VBoxContainer


var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"
var todoRowScene = preload("res://tabs/to_do_row.tscn")
var buttonScene = preload("res://context_button.tscn")
var makingList = false
#var tabName = "todo"

const SAVE_SECTION = "TODO_TAB"

func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveTodoButton.pressed.connect(saveTodo)
	%NewListButton.pressed.connect(makingNewList)
	%Name.text_submitted.connect(_textSubmitted)
	%Name.focus_exited.connect(func():makingList = false)
	Globals.deleteSublist.connect(_deleteSublist)
	#
	if not todoLists.keys():
		return
	refreshListsList()
	refreshTodoList()

func _deleteSublist(tab, title):
	if tab == SAVE_SECTION:
		deleteTodo(title)




func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	#print("todo - todoLists: ", todoLists)
	for key in todoLists.keys():
		print("todo tab - key: ", key)
		var newButton = buttonScene.instantiate()
		newButton.pressed.connect(swapActiveList.bind(key))
		newButton.setUp(SAVE_SECTION, key)
		%ListsList.add_child(newButton)


func refreshTodoList():
	#print("todo - ", todoLists[currentList])
	for c in %TodosList.get_children():
		c.queue_free()
	for key in todoLists[currentList].keys():
		#print("todo row - list: ", currentList, ", key: ", key, ", list:", todoLists[currentList][key])
		print("todo tab - key: ", key, ", status: ", todoLists[currentList][key])
		var newRow = todoRowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		newRow.todoToggled.connect(todoToggled)
		newRow.deleteRequested.connect(deleteTodo)
		#newRow.tabName = SAVE_SECTION
		%TodosList.add_child(newRow)




func deleteTodo(todoName):
	todoLists[currentList].erase(todoName)
	saveTodos()
	refreshTodoList()

func todoToggled(title):
	todoLists[currentList][title] = not todoLists[currentList][title]
	#print("todo - todo toggled: ", name, ", ", isCompleted, ", list: ", todoLists[currentList])
	print("todo - todo toggled: ", todoLists[currentList][title])
	saveTodos()
	print("todo - saved")

func makeStrikeVisible(buttonNode):
	setStrikeDimension(buttonNode)
	buttonNode.getNode("Strike").visible = true

func hideStrike(buttonNode):
	buttonNode.getNode("Strike").visible = false

func setStrikeDimension(buttonNode):
	#print("todo row -  %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/newActiveTawTitle.get_rect().size)
	var buttonSize = buttonNode.get_rect().size
	var extraOffset = buttonSize * 0.2
	buttonNode.getNode("Strike").points[1] = buttonSize + extraOffset

func showContext():
	print("context - openning")
	Globals.openContextMenuRef = $'.'
	#Globals.openContextMenuRef = $Menu
	$ContextPopup.visible = true

func hideContext():
	Globals.openContextMenuRef = null
	$ContextPopup.visible = false




func _textSubmitted(newText):
	saveTodo()



func makingNewList():
	makingList = true
	%Name.grab_focus()


func saveTodo():
	if makingList:
		saveNewList()
	else:
		saveNewTodo()

func saveNewList():
	#print("todo - new list is: ", %TodoName.text)
	todoLists[%Name.text] = {}
	refreshListsList()
	swapActiveList(%Name.text)
	clearInputBar()
	makingList = false
	saveTodos()
	%Name.text = ""
	%Name.grab_focus()

func saveNewTodo():
	#print("todo - new todo is: ", %Name.text)
	todoLists[currentList][%Name.text] = false
	clearInputBar()
	refreshTodoList()
	saveTodos()
	%Name.text = ""

func saveTodos():
	Saver.saveGameSection(SAVE_SECTION, "todoLists", todoLists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)
	#print("todo - saved")

func clearInputBar():
	%Name.text = ""

func swapActiveList(newList:String):
	currentList = newList
	refreshTodoList()
	saveTodos()


# ui_text_accept
