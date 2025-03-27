extends Node


var menuOpen = false

var speaking = false
var toSayStack = []
var lastSaidStack = []

const defaultSize = Vector2(100, 100)





func _ready():
	#%SpeechOutMenu.add_text("this is some text that I'm saying")
	pass # Replace with function body.




func handleWindowResize(newSize:Vector2):
	get_window().size = newSize





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


func expandMenu():
	#get_window().size = %MainMenu.size + %DraggableArea.size
	get_tree().get_root().get_window().size = Vector2(1000,1000)
	menuOpen = true

func hideMenu():
	print("hiding menu")
	get_window().size = defaultSize
	menuOpen = false






#func sayInMenu(toSay:String, duration:float = 0.0)->void:
	#%SpeechOutMenu.text = toSay
	#if duration > 0:
		#speaking = true
		#await get_tree().create_timer(duration).timeout
		#%SpeechOutMenu.clear()
		#speaking = false
