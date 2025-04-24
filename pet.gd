extends Node2D

# Snippy
# saySomething("hydrate")
# saySomething("stand up / stretch")



# Signals
signal doubleClicked
signal changedScreenCorner



# Sprite transistions
var sprite_standing = load("res://pet_assets/flyMan_still_stand.png") 
var sprite_flying = load("res://pet_assets/flyMan_fly.png") 

# Context
var positionOnScreen = Vector2i(0,0) # 0,0 =top left / 1,1 = bottom right
var contextMenuOpen = false
var openContextMenuRef

func _ready():
	%DraggableArea.gui_input.connect(%Mouse.interpretMouseInput)
	%Mouse.rightClicked.connect(UI.toggleMenu)
	#%UI.sayInMenu(" hello from the main script")
	#%JokeButton.pressed.connect(%Behaviour.tellJoke)
	%DialogueBox.visible = false
	%ContextPopup.visible = false
	Globals.contextMenuRef = %ContextPopup
	%Hotbar.shortcutPressed.connect(%DialogueBox.jumpToList)
	#%Hotbar.tab_changed.connect()





func _process(_delta):
	$Mouse.handleDragging() # handles dragging the window around with the mouse
	handleDragAnimation() # change animation while being dragged
	


func handleDragAnimation()->void:
	# change sprite on drag
	# MAYBE implement "draggingDirection" (Vector?) property in the future
	if %Mouse.beingDragged and not %Sprite.texture == sprite_flying:
		#print("dragging, switching to flying sprite")
		%Sprite.texture = sprite_flying
	else: if not %Mouse.beingDragged and not %Sprite.texture == sprite_standing:
		#print("stopped dragging, switching to standing sprite")
		%Sprite.texture = sprite_standing
