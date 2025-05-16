extends VBoxContainer


var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"
var currentListButton:Node
#var todoRowScene = preload("res://tabs/to_do_row.tscn")
var buttonScene = preload("res://context_button.tscn")
var makingList = false

var makingDuplicate:bool = false
var duplicatingList:String = ""

#var tabName = "todo"

const SAVE_SECTION = "TODO_TAB"

func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveTodoButton.pressed.connect(saveTodo)
	%NewListButton.pressed.connect(makingNewList)
	%Name.text_submitted.connect(_textSubmitted)
	%Name.focus_exited.connect(_focusLost)
	#
	if not todoLists.keys():
		return
	refreshListsList()
	highlightListList(currentList)
	refreshTodoList()

func _focusLost():
	makingList = false
	makingDuplicate = false
	duplicatingList = ""
	%Name.placeholder_text = "New Todo"

func highlightListList(listName:String):
	var button = getListListButton(listName)
	print("todo tab - hightlighting list: ", listName, ", button: ", button)
	var newStyle = makeHighlightedButtonStylebox()
	button.add_theme_stylebox_override("normal", newStyle)
	button.add_theme_stylebox_override("hover", newStyle)
	button.add_theme_stylebox_override("pressed", newStyle)
	if currentListButton and currentListButton != button:
		currentListButton.remove_theme_stylebox_override("normal")
		currentListButton.remove_theme_stylebox_override("hover")
		currentListButton.remove_theme_stylebox_override("pressed")
	currentListButton = button


func getListListButton(listName:String):
	for c in %ListsList.get_children():
		if "title" in c:
			if c.title == listName:
				return c

func makeHighlightedButtonStylebox()->StyleBoxFlat:
	var newStyle = StyleBoxFlat.new()
	newStyle.bg_color = Color(0.498039, 1, 0, 0.3) # CHARTREUSE
	return newStyle



func duplicateList(listName):
	print("todo tab - duplicate list")
	makingDuplicate = true
	duplicatingList = listName
	%Name.grab_focus()
	%Name.placeholder_text = "New Duplicate List Name"


func deleteListItem(todoName):
	print("todo tab - deleting: ", todoName)
	todoLists[currentList].erase(todoName)
	saveTodos()
	refreshTodoList()

func deleteList(listName):
	print("todo tab - deleting list: ", listName)
	todoLists.erase(listName)
	currentList = todoLists.keys()[0]
	Globals.deleteHotbarShortcut.emit(listName)
	saveTodos()
	refreshListsList()

func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	#print("todo - todoLists: ", todoLists)
	for key in todoLists.keys():
		#print("todo tab - key: ", key)
		var newButton = buttonScene.instantiate()
		newButton.pressed.connect(swapActiveList.bind(key))
		newButton.setUp(SAVE_SECTION, key, false, )
		newButton.deleteRequested.connect(deleteList)
		newButton.duplicateRequested.connect(duplicateList)
		%ListsList.add_child(newButton)


func refreshTodoList():
	#print("todo - ", todoLists[currentList])
	for c in %TodosList.get_children():
		c.queue_free()
	sortByCompleted()
	for key in todoLists[currentList].keys():
		#print("todo tab - list: ", currentList, ", key: ", key, ", list:", todoLists[currentList][key])
		#print("todo tab - key: ", key, ", status: ", todoLists[currentList][key])
		var newRow = todoRowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		newRow.todoToggled.connect(todoToggled)
		newRow.deleteRequested.connect(deleteListItem)
		
		#newRow.tabName = SAVE_SECTION
		%TodosList.add_child(newRow)




func sortByCompleted():
	for key in todoLists[currentList].keys():
		if todoLists[currentList][key]:
			todoLists[currentList].erase(key)
			todoLists[currentList][key] = true






func todoToggled(title):
	todoLists[currentList][title] = not todoLists[currentList][title]
	#print("todo - todo toggled: ", todoLists[currentList][title])
	saveTodos()

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


func _textSubmitted(newText):
	saveTodo()

func makingNewList():
	makingList = true
	%Name.grab_focus()
	%Name.placeholder_text = "New List Name"

func saveTodo():
	if makingList:
		saveNewList()
	elif makingDuplicate:
		saveNewDuplicateList()
	else:
		saveNewTodo()

func saveNewDuplicateList():
	print("todo tab - saving duplicate list: ", duplicatingList)
	var capitalized = Globals.customCapitalize(%Name.text)
	todoLists[capitalized] = todoLists[duplicatingList].duplicate()
	refreshListsList()
	swapActiveList(capitalized)
	clearInputBar()
	makingDuplicate = false
	duplicatingList = ""
	saveTodos()
	cleanInputBar()


func saveNewList(isDuplicate=false):
	#print("todo - new list is: ", %TodoName.text)
	var capitalized = Globals.customCapitalize(%Name.text)
	todoLists[capitalized] = {}
	refreshListsList()
	swapActiveList(capitalized)
	clearInputBar()
	makingList = false
	saveTodos()
	cleanInputBar()

func cleanInputBar():
	%Name.text = ""
	%Name.placeholder_text = "New Todo"
	%Name.grab_focus()



func saveNewTodo():
	#print("todo - new todo is: ", %Name.text)
	var capitalized = Globals.customCapitalize(%Name.text)
	todoLists[currentList][capitalized] = false
	clearInputBar()
	refreshTodoList()
	saveTodos()
	%Name.text = ""

func saveTodos():
	Saver.saveGameSection(SAVE_SECTION, "todoLists", todoLists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)
	#print("todo - saved")

func swapActiveList(newList:String):
	currentList = newList
	refreshTodoList()
	highlightListList(currentList)
	saveTodos()



func clearInputBar():
	%Name.text = ""



# ui_text_accept
