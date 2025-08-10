extends PanelContainer


const groupsMenuButtonScene = preload("res://ui/common/context_button/context_popup_groups_item.tscn")

var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"
var isHotbarShortcut = false
#var callerButton



func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%DuplicateButton.pressed.connect(duplicateList)
	%DeleteButton.pressed.connect(delete)
	%EditButton.pressed.connect(_editPressed)
	%GroupButton.pressed.connect(switchToGroupingMenu)



func switchToGroupingMenu():
	for c in %GroupingMenuList.get_children():
		c.queue_free()
	for gId in Groups.getGroupIds():
		var newRow = createButtonForGroupingMenu(Groups.getGroup(gId))
		%GroupingMenuList.add_child(newRow)
	$MarginContainer/GroupingMenu.visible = true
	$MarginContainer/MainMenu.visible = false




func createButtonForGroupingMenu(groupDict):
	var groupButton = groupsMenuButtonScene.instantiate()
	var isActive = Globals.contextMenuCallerButton.buttonData.groups.has(groupDict.id)
	groupButton.setup(groupDict, isActive)
	groupButton.s_addedToGroup.connect(groupsUpdated)
	groupButton.s_removedFromGroup.connect(groupsUpdated)
	return groupButton



func groupsUpdated(_in):
	Globals.contextMenuCallerButton.s_groupsUpdated.emit(groupIdsFromSelection())


func groupIdsFromSelection():
	var gIds = []
	for groupButton in %GroupingMenuList.get_children():
		var groupButtonDict = groupButton.getDict()
		if groupButtonDict.active:
			gIds.append(groupButtonDict.id)
	return gIds








func _editPressed():
	Globals.contextMenuTriggeredEdit()

func duplicateList():
	Globals.contextMenuTriggeredDuplicateList()

func copy():
	Globals.contextMenuTriggeredCopy()

func delete():
	Globals.contextMenuTriggeredDelete()
	#print("context popup - deleting: ", tabName, ", ", title)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		#var evLocal = make_input_local(event)
		# check if click is outside of menu, close if so
		if !Rect2(Vector2(0,0), size).has_point(make_input_local(event).position):
			#release_focus()
			#if popOutMenuVisible:
			Globals.hideContextButtonMenu()


#func setUp(tab, list, isShortcut = false, sublistItem = ""):
func setUp(buttonData):
	switchOutOfGroupingMenu()
	title = "list"
	tabName = "tab"
	isHotbarShortcut = buttonData.isHotbarShortcut
	task = "sublistItem"
	%EditButton.visible = buttonData.canBeEdited
	%DeleteButton.visible = buttonData.canBeDeleted
	%DuplicateButton.visible = buttonData.canBeDuplicated
	%CopyButton.visible = buttonData.canBeCopied
	%GroupButton.visible = buttonData.canBeGrouped
	%AddToHotbarButton.visible = buttonData.canBeHotbarShortcut
	$'.'.size = Vector2.ZERO
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	#print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)
	$'.'.visible = false

func deleteHotbarShortcut():
	Globals.deleteHotbarShortcut.emit(title)
	$'.'.visible = false



func switchOutOfGroupingMenu():
	$MarginContainer/GroupingMenu.visible = false
	$MarginContainer/MainMenu.visible = true
	$'.'.size = Vector2.ZERO


#
