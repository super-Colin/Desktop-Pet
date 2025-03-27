extends PanelContainer







func _ready() -> void:
	%WidthSlider.drag_ended.connect(handleChangeWidth)
	%HeightSlider.drag_ended.connect(handleChangeHeight)


func handleChangeWidth(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))
