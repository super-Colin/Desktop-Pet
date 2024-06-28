extends Control

signal doubleClicked

var mouseHeldFrames = 0
var mouseStart: Vector2i
var beingDragged = false

var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 



func _ready()->void:
	$'.'.gui_input.connect(setDraggingStatus)



func _process(_delta)->void:
	handleDragging()


func handleDragging()->void:
	if beingDragged: # set by setDraggingStatus
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart
	handleDragAnimation()



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




func say(toSay:String, duration:float = 5.0)->void:
	%SpeechBox.visible = true
	%Speech.text = toSay
	await get_tree().create_timer(duration).timeout
	#%SpeechBox.visible = false
	return




