extends Control


var mouseStart: Vector2i
var moving = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$'.'.gui_input.connect(onDrag)


	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving:
		var mouseDelta = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouseDelta - mouseStart





func onDrag(event)->void:
	#print(event)
	if event is InputEventMouseButton and event.button_index == 1:
		#mouseStart = 
		if ! moving:
			mouseStart = get_viewport().get_mouse_position()
		moving = event.pressed


