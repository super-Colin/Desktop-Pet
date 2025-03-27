extends PanelContainer







func _ready() -> void:
	%WidthSlider.drag_ended.connect(handleChangeWidth)


func handleChangeWidth(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	print("box - val: ", valChanged)
	get_tree().get_root().get_window().size = Vector2(%WidthSlider.value, currentSize.y)
