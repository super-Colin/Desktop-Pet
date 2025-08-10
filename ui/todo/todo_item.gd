extends HBoxContainer




signal s_editSubmitted(dataDict)
signal s_deleteMe(dataDict)
signal s_groupsUpdated(newGroupIds:Array)
signal s_toggled(isDone:bool)

var itemName
var priorityLevel
var groups = []






func _ready() -> void:
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_deleteRequested.connect(func():s_deleteMe.emit(itemName))
	$PriorityLevel.item_selected.connect(priorityLevelEdited)
	%ContextButton.s_groupsUpdated.connect(groupsUpdated)


# Bookcase / shelf
# Sort by group


func groupsUpdated(newGroupIds):
	print("todo item - groups updated:", newGroupIds)
	setGroupIconColor(newGroupIds)
	s_groupsUpdated.emit(newGroupIds)



func priorityLevelEdited(newOptionIndex):
	priorityLevel = int($PriorityLevel.get_item_text(newOptionIndex))
	var currentInfo = {
		"name": itemName,
		"groups": groups,
	}
	_editSubmitted(currentInfo)

func _editSubmitted(newButtonData):
	#print("group item - edit submitted")
	var todoData = {
		#"listId":groupId,
		"name":newButtonData.name,
		#"color":newButtonData.color,
		"groups":newButtonData.groups,
		"priority":priorityLevel,
	}
	if not itemName == todoData.name:
		#print("todo item - need to delete renamed item")
		todoData.deleteOld = itemName
	s_editSubmitted.emit(todoData)
	#setGroupColor()


func setGroupIconColor(groupIds:Array):
	$GroupsIcon.setColorsWithGroups(groupIds)

func setup(todoDict):
	var buttonData = {
		"name":todoDict.name,
		#"color":groupDict.color,
		#"tabName":"TODOS",
	}
	itemName = todoDict.name
	priorityLevel = todoDict.priority
	setPriorityLevel()
	#buttonData.editingWhenLoaded = forNewItemCreation
	%ContextButton.setup(buttonData)
	if todoDict.has("groups"):
		$GroupsIcon.setColorsWithGroups(todoDict.groups)

func setPriorityLevel():
	$PriorityLevel.select(priorityLevel)


#
