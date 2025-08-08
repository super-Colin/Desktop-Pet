extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"
var isHotbarShortcut = false
var callerButton



func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%Duplicate.pressed.connect(duplicateList)
	%DeleteButton.pressed.connect(delete)
	%EditButton.pressed.connect(_editPressed)

func _editPressed():
	Globals.contextMenuTriggeredEdit()

func duplicateList():
	Globals.popupTriggeredDuplicateList()

func copy():
	Globals.popupTriggeredCopy()

func delete():
	Globals.popupTriggeredDelete()
	#print("context popup - deleting: ", tabName, ", ", title)




#func setUp(tab, list, isShortcut = false, sublistItem = ""):
func setUp(buttonData):
	title = "list"
	tabName = "tab"
	isHotbarShortcut = buttonData.isHotbarShortcut
	task = "sublistItem"
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	#print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)
	$'.'.visible = false

func deleteHotbarShortcut():
	Globals.deleteHotbarShortcut.emit(title)
	$'.'.visible = false
