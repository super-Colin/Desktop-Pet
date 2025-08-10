extends HBoxContainer

signal s_addedToGroup(gId)
signal s_removedFromGroup(gId)

var groupId


func getDict():
	return{
		"name":$CheckBox.text,
		"id":groupId,
		"active":$CheckBox.button_pressed,
	}


func setup(groupDict, currentlyActive=false):
	print("popup group item - group dict is: ", groupDict)
	groupId = groupDict.id
	$GroupsIcon.setColorWithColors([groupDict.color])
	$CheckBox.text = groupDict.name
	$CheckBox.button_pressed = currentlyActive
	$CheckBox.toggled.connect(_toggled)




func _toggled(toggledOn):
	if toggledOn:
		s_addedToGroup.emit(groupId)
	else:
		s_removedFromGroup.emit(groupId)













#
