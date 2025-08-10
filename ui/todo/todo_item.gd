extends HBoxContainer




signal s_editSubmitted(dataDict)
signal s_deleteMe(dataDict)
signal s_groupsUpdated(newGroupIds:Array)
signal s_toggled(todoItemName, isDone:bool)

var itemName
var priorityLevel
var groups = []
var completed = false





func _ready() -> void:
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_deleteRequested.connect(func():s_deleteMe.emit(itemName))
	$PriorityLevel.item_selected.connect(priorityLevelEdited)
	Groups.s_groupsUpdated.connect(refreshGroupColors)
	%ContextButton.s_groupsUpdated.connect(groupsUpdated)
	%ContextButton.pressed.connect(todoToggled)
	%ContextButton.resized.connect(setCompletion)



func todoToggled():
	completed = ! completed
	setCompletion()
	s_toggled.emit(itemName, completed)


func setup(todoDict):
	var buttonData = {
		"name":todoDict.name,
		#"color":groupDict.color,
		#"tabName":"TODOS",
		#"groups":todoDict.groups
	}
	
	itemName = todoDict.name
	priorityLevel = todoDict.priority
	setPriorityLevel()
	#buttonData.editingWhenLoaded = forNewItemCreation
	if todoDict.has("groups"):
		$GroupsIcon.setColorsWithGroups(todoDict.groups)
		buttonData.groups = todoDict.groups
		groups = todoDict.groups
	completed = todoDict.completed
	%ContextButton.setup(buttonData)
	setCompletion()
	#call_deferred("setCompletion")


func setCompletion():
	if completed:
		var btnSize = %ContextButton.get_rect().size
		$ScrollContainer/ContextButton/StrikeLine.visible = true
		$ScrollContainer/ContextButton/StrikeLine.points[0] = Vector2(0, btnSize.y/2)
		$ScrollContainer/ContextButton/StrikeLine.points[1] = Vector2(btnSize.x, btnSize.y/2)
	else:
		$ScrollContainer/ContextButton/StrikeLine.visible = false





func _editSubmitted(newButtonData):
	#print("group item - edit submitted")
	var todoData = {
		"name":newButtonData.name,
		#"color":newButtonData.color,
		"groups":newButtonData.groups,
		"priority":priorityLevel,
		#"completed":completed,
	}
	if not itemName == todoData.name:
		#print("todo item - need to delete renamed item")
		todoData.deleteOld = itemName
	s_editSubmitted.emit(todoData)
	#setGroupColor()






func groupsUpdated(newGroupIds):
	print("todo item - groups updated:", newGroupIds)
	groups = newGroupIds
	setGroupIconColor(newGroupIds)
	s_groupsUpdated.emit(newGroupIds)


func setGroupIconColor(groupIds:Array):
	$GroupsIcon.setColorsWithGroups(groupIds)

func refreshGroupColors():
	groupsUpdated(groups)



func setPriorityLevel():
	$PriorityLevel.select(priorityLevel)

func priorityLevelEdited(newOptionIndex):
	priorityLevel = int($PriorityLevel.get_item_text(newOptionIndex))
	var currentInfo = {
		"name": itemName,
		"groups": groups,
	}
	_editSubmitted(currentInfo)



#
