extends Button


signal left_click(nodeRef)
signal right_click(nodeRef)

var title:String
var contextIsOpen = false
var tabName
var isHotbarShortcut = false



func _ready() -> void:
	#$'.'.pressed.connect(func():Globals.toggleContextMenu($'.', tabName, title))
	gui_input.connect(onButtonGuiInput)
	Globals.contextMenuClosed.connect(func():contextIsOpen = false)


func onButtonGuiInput(event=null):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
				if contextIsOpen:
					Globals.hideContextPopup($'.')
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
				#print("context button - ", $'.', ", ", tabName, ", ",title)
				Globals.toggleContextMenu($'.', tabName, title, isHotbarShortcut)
				

func setUp(tab, label, isShortcut = false):
	print("context button - set up; tab: ", tab, ", label: ", label, ", is shortcut: ", isShortcut)
	tabName = tab
	title = label
	isHotbarShortcut = isShortcut
	$'.'.text = title
