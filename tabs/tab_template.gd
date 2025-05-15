extends VSplitContainer
class_name TabTemplate



var lists:Dictionary = {}
var currentList:String = ""
var currentListButton:Node
#var todoRowScene = preload("res://tabs/to_do_row.tscn")
@export var rowScene:PackedScene
var buttonScene = preload("res://context_button.tscn")
var makingList = false

var makingDuplicate:bool = false
var duplicatingList:String = ""


@export var SAVE_SECTION = "NEWTYPE_TAB"

@export var rowName = "todo"

func _ready() -> void:
	lists = Saver.loadGameSection(SAVE_SECTION, rowName+"Lists", lists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	%SaveNewButton.pressed.connect(_inputTextSubmitted.bind(%NameInput.text))
	%NewListButton.pressed.connect(makingNewList)
	%NameInput.text_submitted.connect(_inputTextSubmitted)
	%NameInput.focus_exited.connect(_inputFocusLost)
	#
	hideEditor()
	refreshListsList()
	refreshList()
	if not lists.keys():
		makingNewList()
	else:
		highlightListList(currentList)


#region Editor
func hideEditor():
	%Editor.visible = false

func showEditor():
	%Editor.visible = false

#endregion


#region Highlighting Selected List

func swapActiveList(newList:String):
	currentList = newList
	refreshList()
	highlightListList(currentList)
	saveTab()

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

#endregion

#region Make New / Duplicate
func makeNewRow(rowKey):
	var newRow = rowScene.instantiate()
	newRow.setUp(rowKey, lists[currentList][rowKey])
	#newRow.todoToggled.connect(todoToggled)
	return newRow

func makingNewList():
	makingList = true
	%NameInput.grab_focus()
	%NameInput.placeholder_text = "New List Name"

func duplicateList(listName):
	print(rowName +" tab - duplicate list")
	makingDuplicate = true
	duplicatingList = listName
	%NameInput.grab_focus()
	%NameInput.placeholder_text = "New Duplicate List Name"

#endregion

#region Delete
func deleteList(listName):
	print(rowName + " tab - deleting list: ", listName)
	lists.erase(listName)
	currentList = lists.keys()[0]
	Globals.deleteHotbarShortcut.emit(listName)
	saveTab()
	refreshListsList()

func deleteListItem(todoName):
	print(rowName + " tab - deleting: ", todoName)
	lists[currentList].erase(todoName)
	saveTab()
	refreshList()

#endregion

#region Refresh List/s

func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	#print("todo - todoLists: ", todoLists)
	for key in lists.keys():
		#print("todo tab - key: ", key)
		var newButton = buttonScene.instantiate()
		newButton.pressed.connect(swapActiveList.bind(key))
		newButton.setUp(SAVE_SECTION, key, false)
		newButton.deleteRequested.connect(deleteList)
		newButton.duplicateRequested.connect(duplicateList)
		%ListsList.add_child(newButton)

func refreshList():
	#print("todo - ", todoLists[currentList])
	for c in %CurrentList.get_children():
		c.queue_free()
	if not currentList or currentList == "":
		print(rowName +" tab - no current list")
		return
	#sortByCompleted()
	for key in lists[currentList].keys():
		var newRow = makeNewRow(key)
		newRow.deleteRequested.connect(deleteListItem)
		newRow.updated.connect(updateItemData.bind(currentList)) # bind adds args to the end
		newRow.saveRequested.connect(saveTab)
		%CurrentList.add_child(newRow)

#endregion

#region Saving
func updateItemData(itemTitle, data, list):
	lists[list][itemTitle] = data

func saveNewRow():
	#print("todo - new todo is: ", %NameInput.text)
	var capitalized = Globals.customCapitalize(%NameInput.text)
	lists[currentList][capitalized] = {}
	cleanInputBar()
	refreshList()
	saveTab()
	%NameInput.text = ""

func saveTab():
	Saver.saveGameSection(SAVE_SECTION, rowName+"Lists", lists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)
	#print("todo - saved")

func saveNewList():
	#print("todo - new list is: ", %TodoName.text)
	var capitalized = Globals.customCapitalize(%NameInput.text)
	lists[capitalized] = {}
	refreshListsList()
	swapActiveList(capitalized)
	makingList = false
	saveTab()
	cleanInputBar()
	%NameInput.grab_focus()

#endregion 

#region Input
func _inputFocusLost():
	makingList = false
	makingDuplicate = false
	duplicatingList = ""
	%NameInput.placeholder_text = "New " + rowName

func _inputTextSubmitted(_newText):
	if makingList or currentList == "":
		saveNewList()
	else:
		saveNewRow()

func cleanInputBar():
	%NameInput.text = ""
	%NameInput.placeholder_text = "New " + rowName

#endregion


#
