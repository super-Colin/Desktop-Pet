extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"
var task:String = "default"

#
func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)
	%DeleteButton.pressed.connect(deleteSublist)



func deleteSublist():
	if tabName == "HOTBAR":
		Globals.deleteHotbarShortcut.emit(title)
	else:
		Globals.deleteSublist.emit(tabName, title)
	



func setUp(tab, label):
	title = label
	tabName = tab
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)
