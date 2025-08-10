extends HBoxContainer


signal s_editSubmitted(listDict)
signal s_deleteMe
signal s_pressed
signal s_groupsUpdated(newGroupIds:Array)


var groups = []
var listId


func _ready() -> void:
	%ContextButton.pressed.connect(func():s_pressed.emit())
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_deleteRequested.connect(func():s_deleteMe.emit())
	Groups.s_groupsUpdated.connect(refreshGroupColors)
	%ContextButton.s_groupsUpdated.connect(groupsUpdated)




func _editSubmitted(newButtonData):
	print("group item - edit submitted")
	var todoListData = {
		"id":listId,
		"name":newButtonData.name,
		#"color":newButtonData.color,
		"groups":newButtonData.groups
	}
	s_editSubmitted.emit(todoListData)
	#setGroupColor()


func setup(todoListDict, forNewItemCreation = false):
	var buttonData = {
		"name":todoListDict.name,
		#"color":groupDict.color,
		#"tabName":"TODOS",
	}
	listId = todoListDict.id
	#itemName = todoListDict.name
	#buttonData.editingWhenLoaded = forNewItemCreation
	if forNewItemCreation:
		%ContextButton.pressed.connect(func():%ContextButton.startEditingInPlace())
	if todoListDict.has("groups"):
		$GroupsIcon.setColorsWithGroups(todoListDict.groups)
		buttonData.groups = todoListDict.groups
	%ContextButton.setup(buttonData)





func groupsUpdated(newGroupIds):
	print("todo item - groups updated:", newGroupIds)
	groups = newGroupIds
	setGroupIconColor(newGroupIds)
	s_groupsUpdated.emit(newGroupIds)


func setGroupIconColor(groupIds:Array):
	$GroupsIcon.setColorsWithGroups(groupIds)

func refreshGroupColors():
	groupsUpdated(groups)










#
