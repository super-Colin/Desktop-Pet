extends Control

signal doubleClicked

# Dragging
var mouseHeldFrames = 0
var mouseStart: Vector2i
var beingDragged = false

# Sprite transistions
var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 

# Context
@onready var trueScreenSize = getTrueScreenSize()
var onLeftHalfOfScreen = false
var onRightHalfOfScreen = true
var onTopHalfOfScreen = false
var onBottomHalfOfScreen = true

func getTrueScreenSize():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	print("TRUE fullsize: ")
	print(get_window().size)
	print(get_viewport().size)
	print(get_viewport_rect().size)
	print(DisplayServer.get_primary_screen())
	print(DisplayServer.get_screen_count())
	print(DisplayServer.window_get_current_screen())
	print(DisplayServer.get_window_at_screen_position(get_window().position))
	print(DisplayServer.get_window_list())
	print(DisplayServer.screen_get_position())
	#print(DisplayServer.get_window_list())
	#print(DisplayServer.get_window_list())
	#print(DisplayServer.get_window_list())
	#print(DisplayServer.get_window_list())
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	return 2


#This will be a work around for trying to get a true screen size of the current monitor. I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values

# I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values
# I'm trying to tell what part of the screen the game is on and getting unexpected results. I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values (I'm guessing because it has the lowest and highest x values??)


func _ready()->void:
	$'.'.gui_input.connect(setDraggingStatus)
	checkScreenSide()



func _process(_delta)->void:
	handleDragging()





func handleDragging()->void:
	if beingDragged: # set by setDraggingStatus
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart
	handleDragAnimation()



func checkScreenSide():
	#var screenSize = DisplayServer.screen_get_size()
	var screenSize = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	var currentPosition = get_window().position - DisplayServer.screen_get_position()
	#var currentPosition = DisplayServer.screen_get_position()
	print("screen size and position")
	print(screenSize)
	print(currentPosition)
	if currentPosition.x > screenSize.x /2:
		print("right")
	else:
		print("left")
	if currentPosition.y > screenSize.y /2:
		print("bottom")
	else:
		print("top")

func handleDragAnimation()->void:
	# change sprite on drag
	if beingDragged and not $Icon.texture == sprite_flying:
		#print("dragging, switching to flying sprite")
		$Icon.texture = sprite_flying
	else: if not beingDragged and not $Icon.texture == sprite_standing:
		#print("stopped dragging, switching to standing sprite")
		$Icon.texture = sprite_standing



func setDraggingStatus(event)->void:
	#print(event)
	if event is InputEventMouseButton and event.double_click:
		print("doubled!")
		doubleClicked.emit()
		#return
	if event is InputEventMouseButton and event.button_index == 1:
		mouseHeldFrames +=1
		if ! beingDragged:
			mouseStart = get_viewport().get_mouse_position()
		beingDragged = event.pressed
		checkScreenSide()




func say(toSay:String, duration:float = 5.0)->void:
	%SpeechBox.visible = true
	%Speech.text = toSay
	await get_tree().create_timer(duration).timeout
	#%SpeechBox.visible = false
	return




