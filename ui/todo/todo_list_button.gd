extends HBoxContainer


signal s_editSubmitted
signal s_deleteList(lId)
signal s_pressed

var groups = []
var listId


func _ready() -> void:
	%ContextButton.pressed.connect(func():s_pressed.emit())
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_deleteRequested.connect(func():s_deleteList.emit(listId))




func _editSubmitted(newButtonData):
	print("group item - edit submitted")
	var todoListData = {
		"id":listId,
		"name":newButtonData.name,
		#"color":newButtonData.color,
		#"groups":newButtonData.groups
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
	%ContextButton.setup(buttonData)
	if forNewItemCreation:
		%ContextButton.pressed.connect(func():%ContextButton.startEditingInPlace())
	if todoListDict.has("groups"):
		$GroupsIcon.setColorsWithGroups(todoListDict.groups)











func setGroupIconColor(groupIds:Array):
	$GroupsIcon.setColorsWithGroups(groupIds)




#
