extends HSplitContainer

const rowScene = preload("res://ui/groups/group_item.tscn")

const SAVE_SECTION = "GROUPS_TAB"



func _ready() -> void:
	Groups.s_groupsUpdated.connect(refreshGroupsList)
	refreshGroupsList()


func refreshGroupsList():
	for c in %GroupsList.get_children():
		c.queue_free()
	for g in Groups.getGroupsAsArray():
		makeRowForGroup(g)
	makeRowForNewGroupCreation()


func makeRowForGroup(groupDict):
	print("groups tab - making row for group: ", groupDict)
	var newRow = rowScene.instantiate()
	newRow.setup(groupDict)
	newRow.s_editSubmitted.connect(_editSubmitted)
	%GroupsList.add_child(newRow)


func makeRowForNewGroupCreation():
	var newRow = rowScene.instantiate()
	newRow.setup(Groups.validateNewGroup({"name":"New Group"}), true)
	newRow.s_editSubmitted.connect(_editSubmitted)
	%GroupsList.add_child(newRow)


func _editSubmitted(groupData):
	print("groups tab - edit submitted")
	Groups.saveGroup(groupData)
	refreshGroupsList()




#
