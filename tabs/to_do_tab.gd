extends VBoxContainer


var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"
var todoRowScene = preload("res://tabs/to_do_row.tscn")
var buttonScene = preload("res://context_button.tscn")




var makingList = false

const SAVE_SECTION = "todo_tab"

func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveTodoButton.pressed.connect(saveTodo)
	%NewListButton.pressed.connect(makingNewList)
	%Name.text_submitted.connect(_textSubmitted)
	%Name.focus_exited.connect(func():makingList = false)
	#
	if not todoLists.keys():
		return
	refreshListsList()
	refreshTodoList()





func refreshTodoList():
	#print("todo - ", todoLists[currentList])
	for c in %TodosList.get_children():
		c.queue_free()
	for key in todoLists[currentList].keys():
		var newRow = todoRowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		newRow.todoToggled.connect(todoToggled)
		newRow.deleteRequested.connect(deleteTodo)
		connectTodoRow(newRow, key, todoLists[currentList][key])
		%TodosList.add_child(newRow)




func connectTodoRow(rowNode, title, completed):
	rowNode.todoToggled.connect(todoToggled.bind(rowNode, title, completed))
	rowNode.setUp(title, completed)
	#$HBoxContainer/Title.toggled.connect(updateCompletedStatusStyles)
	#buttonNode.pressed.connect(func():deleteRequested.emit.bind()()

func deleteTodo(todoName):
	todoLists[currentList].erase(todoName)
	refreshTodoList()

func todoToggled(buttonNode, title, completed):
	todoLists[currentList][name] = not todoLists[currentList][name]
	#print("todo - todo toggled: ", name, ", ", isCompleted, ", list: ", todoLists[currentList])
	saveTodos()
	#if todoLists[currentList][name]:
		#makeStrikeVisible(buttonNode)
		
		


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



#func updateCompletedStatusStyles(completed:bool):
	#isComplete = completed
	#if isComplete:
		#var t = Timer.new()
		#t.wait_time = 0.1
		#t.autostart = true
		#t.one_shot = true
		#t.timeout.connect(makeStrikeVisible)
		#$'.'.add_child(t)
	#else:
		#%Strike.visible = false
	#todoToggled.emit(title, $HBoxContainer/Title.button_pressed)





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

func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	for key in todoLists.keys():
		var newButton = Button.new()
		newButton.text = key
		newButton.pressed.connect(swapActiveList.bind(key))
		%ListsList.add_child(newButton)

# ui_text_accept
