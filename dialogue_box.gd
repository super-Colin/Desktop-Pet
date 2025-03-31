extends PanelContainer



signal left_click
signal right_click



func _ready() -> void:
	gui_input.connect(onButtonGuiInput)


func onButtonGuiInput(event=null):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
			MOUSE_BUTTON_RIGHT:
				print("dialogue - hiding context popup")
				right_click.emit()
				Globals.hideContextPopup()





func flipHotbarButtonOrder():
	print("dialogue - flipping hotbar")
	var i = -1
	for c in %Hotbar.get_children():
		%Hotbar.move_child(c, i)
		i -= 1
	if UI.xAlignment == "right":
		%Hotbar.set_anchors_preset(Control.PRESET_CENTER_LEFT)
		%Hotbar.size_flags_horizontal = SIZE_SHRINK_BEGIN
	else:
		%Hotbar.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		%Hotbar.size_flags_horizontal = SIZE_SHRINK_END



func handleChangeWidth(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))
