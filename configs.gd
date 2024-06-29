extends Node


# These are basically lower level "Project Settings"
# These should only be things that run once on ready
# They are more a convienence for the dev than anything...

@export var useCodeConfigs: bool = true



#The size of the sprite being used
@onready var spriteSize = %Sprite.texture.get_size()
@onready var spriteStartingScale = %Sprite.scale

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set configs where needed based on above
	if useCodeConfigs:
		print("setting configs through code")
		#%DraggableArea.size = spriteSize
		configSpriteSizeBased()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func configSpriteSizeBased():
	# Set size of the draggable area to the size of the sprite
	%DraggableArea.custom_minimum_size = spriteSize
	# Position the sprite in the center of the draggable area
	print(%Sprite)
	%Sprite.position = (spriteSize / 2) - Vector2(1,1)
	get_window().size = spriteSize + Vector2(1,1)
	#print($"../CanvasLayer/GridContainer".anchors_preset)
	#$"../CanvasLayer/GridContainer".anchors_preset = 8
	#$"../CanvasLayer/GridContainer".position = Vector2.ZERO # -1 to account for empty ui container on the side and top
	$"../CanvasLayer/GridContainer".position = Vector2(-2, -2) # -2 to account for empty ui container on the side and top



 #Rect2 get_rect() const
#
#Returns a Rect2 representing the Sprite2D's boundary in local coordinates. Can be used to detect if the Sprite2D was clicked.
#
#Example:
#
#func _input(event):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#if get_rect().has_point(to_local(event.position)):
			#print("A click!")


