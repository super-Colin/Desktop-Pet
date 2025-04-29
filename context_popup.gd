extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"
var isHotbarShortcut = false
var callerButton



func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%DeleteButton.pressed.connect(delete)



func copy():
	Globals.popupTriggeredCopy()

func delete():
	Globals.popupTriggeredDelete()
	#print("context popup - deleting: ", tabName, ", ", title)




func setUp(tab, list, isShortcut = false, sublistItem = ""):
	title = list
	tabName = tab
	isHotbarShortcut = isShortcut
	task = sublistItem
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	#print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)
	$'.'.visible = false

func deleteHotbarShortcut():
	Globals.deleteHotbarShortcut.emit(title)
	$'.'.visible = false
