extends Node


# Snippy

# These are basically lower level "Project Settings"
# These should only be things that run once on ready
# They are more a convienence for the dev than anything...


# Time between holding a click down turning into a dragging action
var clickToDragTimeout = 0.08
# Time between holding a click down and up being a "single click" action
var clickToSingleClickTimeout = 0.14
# Wait this long for a double click befoer calling it a single click
# To prevent single clicks happening on double clicks
# Added on top of single click timeout
var doubleClickBuffer = 0.14
# There is some overlap on these 
# So it's possible to drag and single click in one motion
# But the timing is so small it's negligible


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func configSpriteSizeBased():
	# Set size of the draggable area to the size of the sprite
	%DraggableArea.custom_minimum_size = spriteSize
	# Position the sprite in the center of the draggable area
	print(%Sprite)
	#%Sprite.position = (spriteSize / 2) - Vector2(1,1)
	get_window().size = spriteSize + Vector2(1,1)
	#print($"../CanvasLayer/GridContainer".anchors_preset)
	#$"../CanvasLayer/GridContainer".anchors_preset = 8
	#%GridWrapper.position = Vector2(-2, -2) # -2 to account for empty ui container on the side and top



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
