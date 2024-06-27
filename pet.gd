extends Control


var mouseStart: Vector2i
var beingDragged = false


var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 



# Called when the node enters the scene tree for the first time.
func _ready():
	$'.'.gui_input.connect(onDrag)


	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if beingDragged: # set by onDrag
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart
	handleDragAnimation()




func onDrag(event)->void:
	if event is InputEventMouseButton and event.button_index == 1:
		if ! beingDragged:
			mouseStart = get_viewport().get_mouse_position()
		beingDragged = event.pressed

func handleDragAnimation():
	# change sprite on drag
	if beingDragged:
		$Icon.texture = sprite_flying
	else:
		$Icon.texture = sprite_standing
		
	#print($Icon.texture)
	pass




