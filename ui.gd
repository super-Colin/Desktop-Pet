extends Node


var menuOpen = false


func _ready():
	pass # Replace with function body.



func toggleMenu():
	if menuOpen:
		hideMenu()
	else:
		expandMenu()
	pass


func expandMenu():
	%MainMenu.visible = true
	#print(get_window().size)
	#print(%GridWrapper.size)
	#print(%DraggableArea.size)
	#print(%MainMenu.size)
	get_window().size = %MainMenu.size + %DraggableArea.size
	menuOpen = true

func hideMenu():
	print("hiding menu")
	get_window().size =%DraggableArea.size
	menuOpen = false
	print(get_window().size)
	
