extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"
var isHotbarShortcut = false
var callerButton



func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%DuplicateButton.pressed.connect(duplicateList)
	%DeleteButton.pressed.connect(delete)
	%EditButton.pressed.connect(_editPressed)

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
		if !Rect2(Vector2(0,0), size).has_point(make_input_local(event).position):
			#release_focus()
			Globals.hideContextButtonMenu()


#func setUp(tab, list, isShortcut = false, sublistItem = ""):
func setUp(buttonData):
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
