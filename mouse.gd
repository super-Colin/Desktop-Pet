extends Node


signal singleClicked
signal doubleClicked
signal rightClicked

signal changedScreenCorner


# Dragging
#var clickToDragTimeout = %'../Config'.clickToDragTimeout
@onready var clickToDragTimeout = %Config.clickToDragTimeout
@onready var clickToSingleClickTimeout = %Config.clickToSingleClickTimeout
var singleClickStarted = false
var doubleClickBuffer = 0.14
var mouseStart: Vector2i
var mouseBeingHeld = false
var beingDragged = false

# Which corner of the current monitor are we on
var currentScreenCorner = Vector2(0,0) # 0,0 =top left / 1,1 = bottom right





func _ready():
	$DragTimer.one_shot = true
	$DragTimer.wait_time = clickToDragTimeout
	$DragTimer.timeout.connect(isDraggingNow)
	
	$ClickTimer.one_shot = true
	$ClickTimer.wait_time = clickToSingleClickTimeout
	
	$DoubleClickBuffer.one_shot = true
	$DoubleClickBuffer.wait_time = doubleClickBuffer
	
	checkScreenCorner()


# "_process" calls are in main Pet script


func handleDragging()->void:
	if mouseBeingHeld and beingDragged: # set by setDraggingStatus
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart
		checkScreenCorner()


# Connect to gui_input
func interpretMouseInput(event: InputEventMouse)->void:
	#print(event)
	# If right click down skip, emit on release
	if event is InputEventMouseButton and event.button_index == 2:
		if event.pressed:
			return
		else:
			#print("Right clicked")
			rightClicked.emit()
	# If double click stop single click timer and stop dragging
	if event is InputEventMouseButton and event.button_index == 1 and event.double_click:
		#print("Double clicked")
		doubleClicked.emit()
		beingDragged = false
		singleClickStarted = false
		$ClickTimer.stop()
		return
	if event is InputEventMouseButton and event.button_index == 1:
		# if the mouse button was pressed down
		if event.pressed:
			mouseBeingHeld = true
			# Make sure our timer is running
			if $DragTimer.is_stopped():
				#print("starting Drag timer")
				$DragTimer.start()
				mouseStart = get_viewport().get_mouse_position()
			if $ClickTimer.is_stopped():
				#print("starting single click timer")
				$ClickTimer.start()
				singleClickStarted = true
			# If the mouse button was released
		else:
			#print("setting mouseBeingHeld to false")
			mouseBeingHeld = false
			beingDragged = false
			$DragTimer.stop()
			if not $ClickTimer.is_stopped():
				doubleClickWaiter()
			#$ClickTimer.stop()


func doubleClickWaiter():
	$DoubleClickBuffer.start()
	#print("Single Click starting wait")
	await $DoubleClickBuffer.timeout
	if singleClickStarted and $DoubleClickBuffer.is_stopped(): # will set to false if it was a double click
		#print("Single Clicked")
		singleClicked.emit()
		singleClickStarted = false
		$ClickTimer.stop()


func isDraggingNow():
	#print("Drag click timer timeout!")
	if mouseBeingHeld and not beingDragged:
		#print("being dragged")
		beingDragged = true

func checkScreenCorner():
	var screenSize = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	# Get the size of the window that the game is currently running on
	var currentPosition = get_window().position - DisplayServer.screen_get_position() + get_window().size /2
	var newCorner = Vector2.ZERO
	if currentPosition.x > screenSize.x /2:
		newCorner.x = 1
	else:
		newCorner.x = 0
	if currentPosition.y > screenSize.y /2:
		newCorner.y = 1
	else:
		newCorner.y = 0
	if not newCorner == currentScreenCorner:
		print("Changed screen corner; from: ", currentScreenCorner, " to: ", newCorner)
		changedScreenCorner.emit()
		currentScreenCorner = newCorner
	#print("Current window corner:")
	#print(positionOnScreen)
