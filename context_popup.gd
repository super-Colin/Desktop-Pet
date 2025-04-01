extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"
var isHotbarShortcut = false



func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%DeleteButton.pressed.connect(delete)




func delete():
	print("context popup - deleting: ", tabName, ", ", title)
	if isHotbarShortcut:
		Globals.deleteHotbarShortcut.emit(title)
	else:
		Globals.deleteSublist.emit(tabName, title)




func setUp(tab, label, isShortcut = false):
	title = label
	tabName = tab
	isHotbarShortcut = isShortcut
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)

func deleteHotbarShortcut():
	Globals.deleteHotbarShortcut.emit(title)
