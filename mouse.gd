extends Node


signal doubleClicked
signal changedScreenCorner

# Dragging
var clickToDragTimeout = %Config.clickToDragTimeout
var mouseStart: Vector2i
var beingDragged = false







# Called when the node enters the scene tree for the first time.
func _ready():
	%DraggableArea.gui_input.connect(setDraggingStatus)
	#%DraggableArea.pressed.connect(func():print("pressed"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass







func setDraggingStatus(event)->void:
	print(event)
	if event is InputEventMouseButton and event.button_index == 1 and event.double_click:
		print("doubled!")
		doubleClicked.emit()
		return
	if event is InputEventMouseButton and event.button_index == 1:
		$ClickTimer.timeout
		clickToDragTimeout = 1
		if ! beingDragged:
			mouseStart = get_viewport().get_mouse_position()
		beingDragged = event.pressed



