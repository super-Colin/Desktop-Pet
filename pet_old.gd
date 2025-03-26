extends Control

signal doubleClicked
signal changedScreenCorner

# Dragging
var mouseHeldFrames = 0
var mouseStart: Vector2i
var beingDragged = false

# Sprite transistions
var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 

# Context
var positionOnScreen = Vector2i(0,0) # 0,0 =top left / 1,1 = bottom right


#This will be a work around for trying to get a true screen size of the current monitor. I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values

# I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values
# I'm trying to tell what part of the screen the game is on and getting unexpected results. I have 2 monitors, one above the other, and it seems to add the y value of the top monitor to the lower, but not the x values (I'm guessing because it has the lowest and highest x values??)


func _ready()->void:
	%DraggableArea.gui_input.connect(setDraggingStatus)
	checkScreenCorner()



func _process(_delta)->void:
	handleDragging()





func handleDragging()->void:
	if beingDragged: # set by setDraggingStatus
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart
	handleDragAnimation()



func checkScreenCorner():
	var screenSize = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	# Get the size of the window that the game is currently running on
	var currentPosition = get_window().position - DisplayServer.screen_get_position() + get_window().size /2
	if currentPosition.x > screenSize.x /2:
		positionOnScreen.x = 1
	else:
		positionOnScreen.x = 0
	if currentPosition.y > screenSize.y /2:
		positionOnScreen.y = 1
	else:
		positionOnScreen.y = 0
	#print("Current window corner:")
	#print(positionOnScreen)

func handleDragAnimation()->void:
	# change sprite on drag
	if beingDragged and not %TheSprite.texture == sprite_flying:
		#print("dragging, switching to flying sprite")
		%TheSprite.texture = sprite_flying
	else: if not beingDragged and not %TheSprite.texture == sprite_standing:
		#print("stopped dragging, switching to standing sprite")
		%TheSprite.texture = sprite_standing



func setDraggingStatus(event)->void:
	print(event)
	if event is InputEventMouseButton and event.double_click:
		print("doubled!")
		doubleClicked.emit()
		#return
	if event is InputEventMouseButton and event.button_index == 1:
		mouseHeldFrames +=1
		if ! beingDragged:
			mouseStart = get_viewport().get_mouse_position()
		beingDragged = event.pressed
		checkScreenCorner()




func say(toSay:String, duration:float = 5.0)->void:
	%SpeechBox.visible = true
	%Speech.text = toSay
	await get_tree().create_timer(duration).timeout
	#%SpeechBox.visible = false
	return
