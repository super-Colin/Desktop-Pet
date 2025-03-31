extends Button


signal left_click(nodeRef)
signal right_click(nodeRef)

var title:String





func _ready() -> void:
	gui_input.connect(_on_Button_gui_input)

func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit($'.')
			MOUSE_BUTTON_RIGHT:
				right_click.emit($'.')
				if Globals.openContextMenuRef:
					Globals.hideContextPopup()
				else:
					showContext()

func setUp(name:String):
	title = name
	$'.'.text = title


func showContext():
	print("context - openning")
	Globals.openContextMenuRef = $'.'
	#Globals.openContextMenuRef = $Menu
	$ContextPopup.visible = true

func hideContext():
	Globals.openContextMenuRef = null
	$ContextPopup.visible = false
