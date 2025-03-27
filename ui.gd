extends Node


var menuOpen = false

var speaking = false
var toSayStack = []
var lastSaidStack = []

const defaultSize = Vector2(125, 140)
var expandedtSize = Vector2(800, 800)

var alwaysOnTop = false

signal toggledAlwaysOnTop(onOrOff)


func _ready():
	#%SpeechOutMenu.add_text("this is some text that I'm saying")
	pass # Replace with function body.




func handleWindowResize(newSize:Vector2):
	expandedtSize = newSize
	get_window().size = expandedtSize





func addToLastSaid(lastThingSaid):
	if lastSaidStack.size() < 3:
		lastSaidStack.append(lastThingSaid)
	else:
		lastSaidStack.pop_front()
		lastSaidStack.append(lastThingSaid)


#func _input(event: InputEvent) -> void:
	#if Input.is_action_pressed("left_click")

#func _physics_process(delta: float) -> void:
	#if %DragResize.button_pressed:
		#print("")


func toggleMenu():
	if menuOpen:
		hideMenu()
	else:
		expandMenu()


func setAlwaysOnTop(on:bool=false): 
	print("ui - always on top: ", on)
	alwaysOnTop = on
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, alwaysOnTop)
	toggledAlwaysOnTop.emit(alwaysOnTop)




func expandMenu():
	#get_window().size = %MainMenu.size + %DraggableArea.size
	get_tree().get_root().get_window().size = expandedtSize
	get_tree().get_first_node_in_group("dialogueBox").visible = true
	menuOpen = true

func hideMenu():
	print("hiding menu")
	get_window().size = defaultSize
	get_tree().get_first_node_in_group("dialogueBox").visible = false
	menuOpen = false






#func sayInMenu(toSay:String, duration:float = 0.0)->void:
	#%SpeechOutMenu.text = toSay
	#if duration > 0:
		#speaking = true
		#await get_tree().create_timer(duration).timeout
		#%SpeechOutMenu.clear()
		#speaking = false
