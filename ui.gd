extends Node


var menuOpen = false

var speaking = false
var toSayStack = []
var lastSaidStack = []



func _ready():
	#%SpeechOutMenu.add_text("this is some text that I'm saying")
	pass # Replace with function body.

func addToLastSaid(lastThingSaid):
	if lastSaidStack.size() < 3:
		lastSaidStack.append(lastThingSaid)
	else:
		lastSaidStack.pop_front()
		lastSaidStack.append(lastThingSaid)
	pass


func toggleMenu():
	if menuOpen:
		hideMenu()
	else:
		expandMenu()
	#menuOpen = not menuOpen


func expandMenu():
	#print(get_window().size)
	#print(%GridWrapper.size)
	#print(%DraggableArea.size)
	#print(%MainMenu.size)
	#%SpeechOutMenu.visible = true
	#get_window().size = %MainMenu.size + %DraggableArea.size
	get_tree().get_root().get_window().size = Vector2(1000,1000)
	menuOpen = true

func hideMenu():
	print("hiding menu")
	get_window().size =%DraggableArea.size
	menuOpen = false






func sayInMenu(toSay:String, duration:float = 0.0)->void:
	%SpeechOutMenu.text = toSay
	if duration > 0:
		speaking = true
		await get_tree().create_timer(duration).timeout
		%SpeechOutMenu.clear()
		speaking = false
