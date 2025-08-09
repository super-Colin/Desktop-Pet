extends HBoxContainer




signal s_editSubmitted(dataDict)
signal s_deleteMe(dataDict)

var listId
var itemName







func _ready() -> void:
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_deleteRequested.connect(func():s_deleteMe.emit())


func _editSubmitted(newButtonData):
	print("group item - edit submitted")
	var todoData = {
		#"listId":groupId,
		"name":newButtonData.name,
		"color":newButtonData.color,
	}
	s_editSubmitted.emit(todoData)
	#setGroupColor()


func setGroupIconColor(groupIds:Array):
	$GroupsIcon.setColorsWithGroups(groupIds)

func setup(todoDict, newListId):
	var buttonData = {
		"name":todoDict.name,
		#"color":groupDict.color,
		#"tabName":"TODOS",
	}
	#listId = newListId
	itemName = todoDict.name
	#buttonData.editingWhenLoaded = forNewItemCreation
	%ContextButton.setup(buttonData)
	if todoDict.has("groups"):
		$GroupsIcon.setColorsWithGroups(todoDict.groups)


#
