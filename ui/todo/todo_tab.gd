extends VBoxContainer



const SAVE_SECTION = "TODO_TAB"

const tabConfig = {
	"tabName":"Todo Lists",
	"tabType":Globals.TabTypes.TODOS,
}

var todoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var currentList:String = "defualt"

var currentListButton:Node
const rowScene = preload("res://ui/groups/group_item.tscn")
const buttonScene = preload("res://ui/common/context_button.tscn")

var makingList = false

var makingDuplicate:bool = false
var duplicatingList:String = ""


func _ready() -> void:
	todoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", todoLists)
	currentList = Saver.loadGameSection(SAVE_SECTION, "currentList", currentList)
	#
	#%SaveTodoButton.pressed.connect(saveTodo)
	#%NewListButton.pressed.connect(makingNewList)
	#%Name.text_submitted.connect(_textSubmitted)
	#%Name.focus_exited.connect(_focusLost)
	##
	#if not todoLists.keys():
		#return
	#refreshListsList()
	#highlightListList(currentList)
	#refreshTodoList()


func _focusLost():
	makingList = false
	makingDuplicate = false
	duplicatingList = ""
	#%Name.placeholder_text = "New Todo"

func refreshTodoList():
	#print("todo - ", todoLists[currentList])
	for c in %TodosList.get_children():
		c.queue_free()
	#sortByCompleted()
	for key in todoLists[currentList].keys():
		#print("todo tab - list: ", currentList, ", key: ", key, ", list:", todoLists[currentList][key])
		#print("todo tab - key: ", key, ", status: ", todoLists[currentList][key])
		var newRow = rowScene.instantiate()
		newRow.setUp(key, todoLists[currentList][key])
		newRow.todoToggled.connect(todoToggled)
		newRow.deleteRequested.connect(deleteListItem)



func todoToggled(title):
	todoLists[currentList][title] = not todoLists[currentList][title]
	#print("todo - todo toggled: ", todoLists[currentList][title])
	# use Strike through to show completed status (maybe also a check mark)
	saveTodos()


func deleteList(listName):
	print("todo tab - deleting list: ", listName)
	todoLists.erase(listName)
	currentList = todoLists.keys()[0]
	Globals.deleteHotbarShortcut.emit(listName)
	saveTodos()
	#refreshListsList()

func deleteListItem(todoName):
	print("todo tab - deleting: ", todoName)
	todoLists[currentList].erase(todoName)
	saveTodos()
	refreshTodoList()












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
	#refreshListsList()
	swapActiveList(capitalized)
	clearInputBar()
	makingDuplicate = false
	duplicatingList = ""
	saveTodos()
	cleanInputBar()


func saveNewList(_isDuplicate=false):
	#print("todo - new list is: ", %TodoName.text)
	var capitalized = Globals.customCapitalize(%Name.text)
	todoLists[capitalized] = {}
	#refreshListsList()
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
	#highlightListList(currentList)
	saveTodos()



func clearInputBar():
	%Name.text = ""



# ui_text_accept


#
