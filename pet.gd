extends Node2D


# Signals
signal doubleClicked
signal changedScreenCorner




# Sprite transistions
var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 

# Context
var positionOnScreen = Vector2i(0,0) # 0,0 =top left / 1,1 = bottom right



func _ready():
	#%DraggableArea.gui_input.connect(setDraggingStatus)
	pass # Replace with function body.


func _process(_delta):
	$Mouse.handleDragging()
	handleDragAnimation()
	


func handleDragAnimation()->void:
	# change sprite on drag
	if %Mouse.beingDragged and not %Sprite.texture == sprite_flying:
		#print("dragging, switching to flying sprite")
		%Sprite.texture = sprite_flying
	else: if not %Mouse.beingDragged and not %Sprite.texture == sprite_standing:
		#print("stopped dragging, switching to standing sprite")
		%Sprite.texture = sprite_standing









# --- Dragging / Detect Double Click ---
#
#
#func handleDragging()->void:
	#if beingDragged: # set by setDraggingStatus
		#var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		#get_window().position += mouseDelta - mouseStart
	#handleDragAnimation()
#
#
#
#func checkScreenCorner():
	#var screenSize = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	## Get the size of the window that the game is currently running on
	#var currentPosition = get_window().position - DisplayServer.screen_get_position() + get_window().size /2
	#if currentPosition.x > screenSize.x /2:
		#positionOnScreen.x = 1
	#else:
		#positionOnScreen.x = 0
	#if currentPosition.y > screenSize.y /2:
		#positionOnScreen.y = 1
	#else:
		#positionOnScreen.y = 0
	##print("Current window corner:")
	##print(positionOnScreen)
#
#func handleDragAnimation()->void:
	## change sprite on drag
	#if beingDragged and not %TheSprite.texture == sprite_flying:
		##print("dragging, switching to flying sprite")
		#%TheSprite.texture = sprite_flying
	#else: if not beingDragged and not %TheSprite.texture == sprite_standing:
		##print("stopped dragging, switching to standing sprite")
		#%TheSprite.texture = sprite_standing
#
#
#
#func setDraggingStatus(event)->void:
	#print(event)
	#if event is InputEventMouseButton and event.double_click:
		#print("doubled!")
		#doubleClicked.emit()
		##return
	#if event is InputEventMouseButton and event.button_index == 1:
		#mouseHeldFrames +=1
		#if ! beingDragged:
			#mouseStart = get_viewport().get_mouse_position()
		#beingDragged = event.pressed
		#checkScreenCorner()
#
## --- END Dragging / Detect Double Click ---
#
#
#
#
#
#
