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
	"completed":false
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
	refreshTab()
	#highlightListList(currentList)
	Groups.s_groupDeleted.connect(removeDeletedGroupFromTab)


func removeDeletedGroupFromTab(groupId):
	for listId in savedTodoLists.keys():
		savedTodoLists[listId].groups.erase(groupId)
		for todoItemKey in savedTodoLists[listId].items.keys():
			savedTodoLists[listId].items[todoItemKey].groups.erase(groupId)
	refreshTab()

func refreshTab():
	refreshListsList()
	refreshTodoItemsList()




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
	makePlaceholderText()

func makePlaceholderText():
	var listName = ""
	if savedCurrentList:
		listName = savedTodoLists[savedCurrentList].name
	%Name.placeholder_text = "New " + listName + " todo item"


func makeListButton(todoListDict, forNewCreation = false):
	var newListButton = listButtonScene.instantiate()
	newListButton.setup(todoListDict, forNewCreation)
	newListButton.s_editSubmitted.connect(saveList)
	if  forNewCreation:
		return newListButton
	newListButton.s_groupsUpdated.connect(updateTodoListGroups.bind(todoListDict.id))
	newListButton.s_pressed.connect(swapActiveList.bind(todoListDict.id))
	newListButton.s_deleteMe.connect(deleteList.bind(todoListDict.id))
	return newListButton



func refreshTodoItemsList():
	for c in %TodosList.get_children():
		c.queue_free()
	if not savedCurrentList:
		return
	print("todo - ", savedTodoLists[savedCurrentList])
	#sortByCompleted()
	for todoItem in savedTodoLists[savedCurrentList].items.values():
		#print("todo tab - list: ", currentList, ", key: ", key, ", list:", todoLists[currentList][key])
		#print("todo tab - key: ", key, ", status: ", todoLists[currentList][key])
		var newItemRow = itemRowScene.instantiate()
		#newItemRow.setup(todoItem, savedCurrentList)
		newItemRow.setup(todoItem)
		newItemRow.s_editSubmitted.connect(updateTodoItem)
		newItemRow.s_deleteMe.connect(deleteTodoItem)
		newItemRow.s_toggled.connect(todoToggled)
		newItemRow.s_groupsUpdated.connect(updateTodoItemGroups.bind(todoItem.name))
		%TodosList.add_child(newItemRow)


func todoToggled(todoItemKey, isDone):
	savedTodoLists[savedCurrentList].items[todoItemKey].completed = isDone
	saveTodos()




func updateTodoListGroups(newGroups, listId):
	savedTodoLists[listId].groups = newGroups
	saveTodos()

func updateTodoItemGroups(newGroups, itemName):
	savedTodoLists[savedCurrentList].items[itemName].groups = newGroups
	saveTodos()


func updateTodoItem(todoItemDict:Dictionary, refreshTodos=true):
	print("todo tab - updated todo item to save is: ", todoItemDict)
	if todoItemDict.has("deleteOld"):
		print("todo tab - deleting old todo item: ", todoItemDict.deleteOld)
		savedTodoLists[savedCurrentList].items.erase(todoItemDict.deleteOld)
	savedTodoLists[savedCurrentList].items[todoItemDict.name] = todoItemDict
	saveTodos()
	if refreshTodos:
		refreshTodoItemsList()

func saveNewTodoItem(_text=null):
	var newItem = {
		"name":%Name.text,
		"priority":5,
		"groups":[],
		"completed":false
	}
	savedTodoLists[savedCurrentList].items[newItem.name] = newItem
	refreshTodoItemsList()
	saveTodos()
	%Name.text = ""



func deleteTodoItem(todoItemName):
	savedTodoLists[savedCurrentList].items.erase(todoItemName)
	refreshTodoItemsList()








func saveList(todoListDict:Dictionary):
	print("todo tab - new list to save is: ", todoListDict)
	#var capitalized = Globals.customCapitalize(%Name.text)
	if not savedTodoLists.has(todoListDict.id):
		savedTodoLists[todoListDict.id] = todoListDict
		savedTodoLists[todoListDict.id].items = {}
		savedTodoLists[todoListDict.id].groups = []
	else:
		savedTodoLists[todoListDict.id].name = todoListDict.name
		#savedTodoLists[todoListDict.id].items = todoListDict.items
		savedTodoLists[todoListDict.id].groups = todoListDict.groups
	savedCurrentList = todoListDict.id
	saveTodos()
	refreshListsList()



func deleteList(listId):
	#print("todo tab - deleting list: ", listName)
	savedTodoLists.erase(listId)
	if listId == savedCurrentList:
		savedCurrentList = savedTodoLists.keys()[0]
	#Globals.deleteHotbarShortcut.emit(listName)
	saveTodos()
	refreshTab()














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



























#func duplicateList(listName):
	#print("todo tab - duplicate list")
	#makingDuplicate = true
	#duplicatingList = listName
	#%Name.grab_focus()
	#%Name.placeholder_text = "New Duplicate List Name"













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
	refreshTodoItemsList()
	#highlightListList(currentList)
	makePlaceholderText()
	saveTodos()
	




# ui_text_accept


#
