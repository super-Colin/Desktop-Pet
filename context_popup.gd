extends PanelContainer


var title:String = "defualt"
var tabName:String = "default"

#
func _ready() -> void:
	#Globals.contextMenuClosed.connect(func():tabName = ""; title = "")
	%AddToHotbarButton.pressed.connect(addHotbarShortcut)


func setUp(tab, label):
	title = label
	tabName = tab
	#%AddToHotbarButton.pressed.connect(addHotbarShortcut)

func addHotbarShortcut():
	print("popup - adding shortcut: ", tabName, ", ", title)
	Globals.addToHotbar(tabName, title)
