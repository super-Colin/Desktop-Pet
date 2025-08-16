extends VBoxContainer



const listButtonScene = preload("res://ui/todo/todo_list_button.tscn")
const itemRowScene = preload("res://ui/todo/todo_item.tscn")

const exampleTodoList = {
	#"id":0, # generated
	"name":"",
	"items":[],
	"groups":[],
}
const exampleTodoItem = {
	#"listId":"", # generated
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
	Groups.s_groupsUpdated.connect(refreshListsList)


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
	#print("todo - todoLists: ", savedTodoLists.keys())
	var topRows = []
	var middleRows = []
	var bottomRows = []
	for listId in savedTodoLists.keys():
		var newListButton = makeListButton(savedTodoLists[listId])
		#print("todo tab - list key: ", listId)
		if savedCurrentList:
			if savedCurrentList == listId:
				currentListButton = newListButton
				newListButton.setButtonPressed(true)
		if Groups.hasATopGroup(savedTodoLists[listId].groups):
			topRows.append(newListButton)
			continue
		if Groups.hasABottomGroup(savedTodoLists[listId].groups):
			bottomRows.append(newListButton)
			continue
		middleRows.append(newListButton)
	# append the sorted and created rows
	for r in topRows:
		%ListsList.add_child(r)
	for r in middleRows:
		%ListsList.add_child(r)
	for r in bottomRows:
		%ListsList.add_child(r)
	# create a button to create a new list
	# give it a name, and have the id be filled in
	var newList = fillInList({"name":"+ New List"})
	# Create button config to create new on load and hide save button
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
	newListButton.s_pressed.connect(swapActiveList.bind(todoListDict.id, newListButton))
	newListButton.s_deleteMe.connect(deleteList.bind(todoListDict.id))
	return newListButton



func refreshTodoItemsList():
	for c in %TodosList.get_children():
		c.queue_free()
	if not savedCurrentList:
		return
	#print("todo - ", savedTodoLists[savedCurrentList])
	#sortByCompleted()
	var sortedItems = sortTodoItems(savedTodoLists[savedCurrentList].items)
	for todoItem in sortedItems:
		#var todoItem = savedTodoLists[savedCurrentList].items[todoItemKey]
		var newItemRow = itemRowScene.instantiate()
		newItemRow.setup(todoItem)
		newItemRow.s_editSubmitted.connect(updateTodoItem)
		newItemRow.s_deleteMe.connect(deleteTodoItem)
		newItemRow.s_toggled.connect(todoToggled)
		newItemRow.s_groupsUpdated.connect(updateTodoItemGroups.bind(todoItem.name))
		%TodosList.add_child(newItemRow)



func sortTodoItems(todoItemsDict:Dictionary)->Array:
	if not todoItemsDict:
		return []
	# sort by completion first
	var completedItems = []
	var uncompletedItems = []
	for key in todoItemsDict.keys():
		if todoItemsDict[key].completed:
			completedItems.append(todoItemsDict[key])
		else:
			uncompletedItems.append(todoItemsDict[key])
	# then sort each bucket by priority
	#print("todo tab - completed items: ", completedItems)
	var sortedUncompletedItems = sortTodoItemsByPriority(uncompletedItems)
	var sortedCompletedItems = sortTodoItemsByPriority(completedItems)
	# append completed to uncompleted so they are on bottom
	sortedUncompletedItems.append_array(sortedCompletedItems)
	var sortedArray = sortedUncompletedItems # uncompleted first (top of list)
	#print("todo tab - sorted items: ", sortedArray)
	return sortedArray

func sortTodoItemsByPriority(todoItemsArray:Array)->Array:
	if not todoItemsArray:
		return []
	var priorityBuckuts = {}
	# make buckets
	var i = 1
	while i <= 9: 
		priorityBuckuts[i] = []
		i += 1
	# put in buckets
	for item in todoItemsArray:
		priorityBuckuts[item.priority].append(item)
	# combine buckets from highest to lowest
	#print("todo tab - sorting priorityBuckuts: ", priorityBuckuts)
	var sortedItems = []
	i = 9
	while i >= 1: 
		sortedItems.append_array(priorityBuckuts[i])
		i -= 1
	#print("todo tab - sortedItems: ", sortedItems)
	return sortedItems



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
	#print("todo tab - new list to save is: ", todoListDict)
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

func swapActiveList(newListId, newButton):
	if newButton == currentListButton:
		currentListButton.setButtonPressed(true)
		return
	currentListButton.setButtonPressed(false)
	currentListButton = newButton
	savedCurrentList = newListId
	refreshTodoItemsList()
	#highlightListList(currentList)
	makePlaceholderText()
	saveTodos()
	




# ui_text_accept


#
