extends Container






func _ready() -> void:
	%WidthSlider.drag_ended.connect(handleChangeWidth)
	%HeightSlider.drag_ended.connect(handleChangeHeight)
	%ShrunkenHeightSlider.drag_ended.connect(handleChangeShrunkenHeight)
	%AlwaysOnTopToggle.toggled.connect(UI.setAlwaysOnTop)
	%Sides.pressed.connect(UI.switchSidesX)
	UI.loaded.connect(setSlidersFromSave)
	setSlidersFromSave()
	
	%Themes.pressed.connect(makeRightClickMenu)

func makeRightClickMenu():
	pass




func handleChangeShrunkenHeight(valChanged):
	UI.handleChangeShrunkenHeight(%ShrunkenHeightSlider.value)

func handleChangeWidth(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))

func setSlidersFromSave():
	var currentSize = get_tree().get_root().get_window().size
	%ShrunkenHeightSlider.value = UI.shrunkenSizeYBuffer
	%WidthSlider.value = UI.expandedSize.x
	%HeightSlider.value = UI.expandedSize.y
	print("hotbar - set sliders, ", UI.shrunkenSizeYBuffer, ", " , currentSize)






#func flipHotbarButtonOrder():
	#print("dialogue - flipping hotbar")
	#var i = -1
	#for c in %Hotbar.get_children():
		#%Hotbar.move_child(c, i)
		#i -= 1
	#if UI.xAlignment == "right":
		#%Hotbar.set_anchors_preset(Control.PRESET_CENTER_LEFT)
		#%Hotbar.size_flags_horizontal = SIZE_SHRINK_BEGIN
	#else:
		#%Hotbar.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		#%Hotbar.size_flags_horizontal = SIZE_SHRINK_END
