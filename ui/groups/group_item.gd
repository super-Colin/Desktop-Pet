extends VBoxContainer


signal s_editSubmitted(dataDict)
signal s_deleteMe(gId)

var groupId

# sort group to top
# (shortcut = true) buttons to get to other tabs

func _ready() -> void:
	%ContextButton.s_editSubmitted.connect(_editSubmitted)
	%ContextButton.s_editRequested.connect(func():%ContextButton.editInPlace())
	%ContextButton.s_deleteRequested.connect(func():s_deleteMe.emit(groupId))
	#Groups.s_groupsUpdated.connect(setGroupColor)
	#$HBoxContainer/GroupsIcon.setColorsWithGroups([groupId])




func _editSubmitted(newButtonData):
	print("group item - edit submitted")
	var groupData = {
		"id":groupId,
		"name":newButtonData.name,
		"color":newButtonData.color,
	}
	s_editSubmitted.emit(groupData)
	setGroupColor()


func setGroupColor(forNewItemCreation = false):
	if forNewItemCreation:
		$HBoxContainer/GroupsIcon.setColorsWithGroups([])
	else:
		$HBoxContainer/GroupsIcon.setColorsWithGroups([groupId])

func setup(groupDict, forNewItemCreation = false):
	var buttonData = {
		"name":groupDict.name,
		"color":groupDict.color,
		#"tabName":"GROUPS",
	}
	groupId = groupDict.id
	buttonData.editingWhenLoaded = forNewItemCreation
	$HBoxContainer/VBoxContainer/HBoxContainer.visible = ! forNewItemCreation
	%ContextButton.setup(buttonData)
	setGroupColor(forNewItemCreation)






#
