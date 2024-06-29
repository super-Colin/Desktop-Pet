extends Node


signal singleClicked
signal doubleClicked
signal changedScreenCorner

# Dragging
#var clickToDragTimeout = %'../Config'.clickToDragTimeout
#var clickToDragTimeout = %Config.clickToDragTimeout
var clickToDragTimeout = 0.08
#var clickToSingleClickTimeout = %Config.clickToSingleClickTimeout
var clickToSingleClickTimeout = 0.14
var singleClickStarted = false
var doubleClickBuffer = 0.14
var mouseStart: Vector2i
var mouseBeingHeld = false
var beingDragged = false







func _ready():
	%DraggableArea.gui_input.connect(interpretMouseInput)
	$DragTimer.wait_time = clickToDragTimeout
	$DragTimer.timeout.connect(isDraggingNow)
	$DragTimer.one_shot = true
	$ClickTimer.wait_time = clickToSingleClickTimeout
	#$ClickTimer.timeout.connect(wasSingleClick)
	$ClickTimer.one_shot = true
	$DoubleClickBuffer.wait_time = doubleClickBuffer
	#$DoubleClickBuffer.timeout.connect(doubleClickWaiter)
	$DoubleClickBuffer.one_shot = true

# _process is in main Pet script



func handleDragging()->void:
	if mouseBeingHeld and beingDragged: # set by setDraggingStatus
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart


# Connect to gui_input
func interpretMouseInput(event)->void:
	#print(event)
	if event is InputEventMouseButton and event.button_index == 1 and event.double_click:
		#print("Double clicked")
		doubleClicked.emit()
		beingDragged = false
		$ClickTimer.stop()
		singleClickStarted = false
		return
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			mouseBeingHeld = true
			# Make sure our timer is running
			if $DragTimer.is_stopped():
				#print("starting Drag timer")
				$DragTimer.start()
				clickToSingleClickTimeout
				mouseStart = get_viewport().get_mouse_position()
			if $ClickTimer.is_stopped():
				#print("starting single click timer")
				$ClickTimer.start()
				singleClickStarted = true
		else: # if the mouse button was released
			#print("setting mouseBeingHeld to false")
			mouseBeingHeld = false
			beingDragged = false
			$DragTimer.stop()
			if not $ClickTimer.is_stopped():
				doubleClickWaiter()
			#$ClickTimer.stop()


func doubleClickWaiter():
	$DoubleClickBuffer.start()
	print("Single Click starting wait")
	await $DoubleClickBuffer.timeout
	if singleClickStarted and $DoubleClickBuffer.is_stopped(): # will set to false if it was a double click
		print("Single Clicked")
		singleClicked.emit()
		singleClickStarted = false
		$ClickTimer.stop()


func isDraggingNow():
	#print("Drag click timer timeout!")
	if mouseBeingHeld and not beingDragged:
		#print("being dragged")
		beingDragged = true



