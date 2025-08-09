extends VBoxContainer



const listButtonScene = preload("res://ui/todo/todo_list_button.tscn")
const itemRowScene = preload("res://ui/todo/todo_item.tscn")

const exampleTodoList = {
	#"id":0,
	"name":"",
	"items":[],
	"groups":[],
}
const exampleTodoItem = {
	#"listId":"",
	"name":"",
	"priority":5,
	"groups":[],
}


const SAVE_SECTION = "TODO_TAB"

const tabConfig = {
	"tabName":"Todo",
	"tabType":Globals.TabTypes.TODOS,
}

var savedTodoLists:Dictionary = {} # "MyTodoList":{"dishes":true}
var savedCurrentList

var currentListButton:Node
#const rowScene = preload("res://ui/groups/group_item.tscn")
#const buttonScene = preload("res://ui/common/context_button.tscn")


var makingDuplicate:bool = false
var duplicatingList:String = ""


func _ready() -> void:
	savedTodoLists = Saver.loadGameSection(SAVE_SECTION, "todoLists", savedTodoLists)
	savedCurrentList = Saver.loadGameSection(SAVE_SECTION, "currentList", savedCurrentList)
	#
	%SaveTodoButton.pressed.connect(saveNewTodoItem)
	%Name.text_submitted.connect(saveNewTodoItem)
	##
	refreshListsList()
	#highlightListList(currentList)
	refreshTodoList()


func saveNewTodoItem(_text=null):
	#print("todo - new todo is: ", %Name.text)
	#var capitalized = Globals.customCapitalize(%Name.text)
	#todoLists[currentList][capitalized] = false
	var newItem = {
		"name":%Name.text,
		"priority":5,
		"groups":[]
	}
	savedTodoLists[savedCurrentList].items.append(newItem)
	#clearInputBar()
	refreshTodoList()
	saveTodos()
	%Name.text = ""




func refreshListsList():
	for c in %ListsList.get_children():
		c.queue_free()
	#print("todo - todoLists: ", todoLists)
	for listId in savedTodoLists.keys():
		#print("todo tab - list key: ", key)
		%ListsList.add_child(makeListButton(savedTodoLists[listId]))
	# create a button to create a new list
	# give it a name, and have the id be filled in
	var newList = fillInList({"name":"+ New List"})
	# Create button config to create new on load and hide save button
	var buttonSetup = {"name":"+ New List"}
	%ListsList.add_child(makeListButton(newList, true))



func makeListButton(todoListDict, forNewCreation = false):
	var newListButton = listButtonScene.instantiate()
	newListButton.setup(todoListDict, forNewCreation)
	newListButton.s_editSubmitted.connect(saveList)
	return newListButton



func refreshTodoList():
	for c in %TodosList.get_children():
		c.queue_free()
	if not savedCurrentList:
		return
	print("todo - ", savedTodoLists[savedCurrentList])
	#sortByCompleted()
	for todoItem in savedTodoLists[savedCurrentList].items:
		#print("todo tab - list: ", currentList, ", key: ", key, ", list:", todoLists[currentList][key])
		#print("todo tab - key: ", key, ", status: ", todoLists[currentList][key])
		var newItemRow = itemRowScene.instantiate()
		newItemRow.setup(todoItem, savedCurrentList)
		#newItemRow.todoToggled.connect(todoToggled)
		#newItemRow.deleteRequested.connect(deleteListItem)
		%TodosList.add_child(newItemRow)












func saveList(todoListDict:Dictionary):
	print("todo tab - new list to save is: ", todoListDict)
	#var capitalized = Globals.customCapitalize(%Name.text)
	if not savedTodoLists.has(todoListDict.id):
		savedTodoLists[todoListDict.id] = todoListDict
		savedTodoLists[todoListDict.id].items = []
		savedTodoLists[todoListDict.id].groups = []
	else:
		savedTodoLists[todoListDict.id].name = todoListDict.name
		#savedTodoLists[todoListDict.id].items = todoListDict.items
		savedTodoLists[todoListDict.id].groups = todoListDict.groups
	savedCurrentList = todoListDict.id
	saveTodos()
	refreshListsList()

















func fillInList(newListDict:Dictionary):
	if not newListDict.has("name") or newListDict.name == "":
		return false
	for key in exampleTodoList.keys():
		if not newListDict.has(key):
			newListDict[key] = exampleTodoList[key]
	if not newListDict.has("id"):
		#newGroupDict.id = randi() % 10000000000
		newListDict.id = randi()
	print("todo tab - filled in list: ", newListDict)
	return newListDict














#func todoToggled(title):
	#todoLists[currentList][title] = not todoLists[currentList][title]
	##print("todo - todo toggled: ", todoLists[currentList][title])
	## use Strike through to show completed status (maybe also a check mark)
	#saveTodos()

#
#func deleteList(listName):
	#print("todo tab - deleting list: ", listName)
	#todoLists.erase(listName)
	#currentList = todoLists.keys()[0]
	#Globals.deleteHotbarShortcut.emit(listName)
	#saveTodos()
	##refreshListsList()

#func deleteListItem(todoName):
	#print("todo tab - deleting: ", todoName)
	#todoLists[currentList].erase(todoName)
	#saveTodos()
	#refreshTodoList()













#func duplicateList(listName):
	#print("todo tab - duplicate list")
	#makingDuplicate = true
	#duplicatingList = listName
	#%Name.grab_focus()
	#%Name.placeholder_text = "New Duplicate List Name"












#func saveTodo():
	##if makingList:
		##saveNewList()
	##elif makingDuplicate:
		##saveNewDuplicateList()
	##else:
	#saveNewTodo()

#func saveNewDuplicateList():
	#print("todo tab - saving duplicate list: ", duplicatingList)
	#var capitalized = Globals.customCapitalize(%Name.text)
	#todoLists[capitalized] = todoLists[duplicatingList].duplicate()
	##refreshListsList()
	#swapActiveList(capitalized)
	#clearInputBar()
	#makingDuplicate = false
	#duplicatingList = ""
	#saveTodos()
	#cleanInputBar()










func saveTodos():
	Saver.saveGameSection(SAVE_SECTION, "todoLists", savedTodoLists)
	Saver.saveGameSection(SAVE_SECTION, "currentList", savedCurrentList)
	#print("todo - saved")

func swapActiveList(newListId):
	savedCurrentList = newListId
	refreshTodoList()
	#highlightListList(currentList)
	saveTodos()




# ui_text_accept


#
