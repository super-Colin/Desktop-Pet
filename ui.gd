extends Node


var menuOpen = false

var speaking = false
var toSayStack = []
var lastSaidStack = []

const defaultSize = Vector2(125, 140)
var shrunkenSize:Vector2 = defaultSize
var expandedSize:Vector2 = Vector2(800, 800)


var alwaysOnTop = false

var xAlignment = "right"
var xShift = 0


signal changedScreenCorner(newCorner)
signal toggledAlwaysOnTop(onOrOff)
signal flippedXAxis
signal expandedSizeUpdated


func _ready():
	changedScreenCorner.connect(handleCornerChange) # Drag area moves out from under mouse... :/ .. could warp mouse??
	pass # Replace with function body.

func handleCornerChange(newCorner):
	if newCorner.x == 0 and xAlignment == "left":
		switchSidesX()
	elif newCorner.x == 1 and xAlignment == "right":
		switchSidesX()


func handleChangeShrunkenHeight(newYBufferSize):
	print("ui - new y buffer: ", newYBufferSize)
	shrunkenSize.y = defaultSize.y + newYBufferSize
	if menuOpen == false:
		get_window().size = shrunkenSize


func handleWindowResize(newSize:Vector2):
	var sizeDif = expandedSize - newSize
	expandedSize = newSize
	get_window().size = expandedSize
	if xAlignment == "left":
		print("box - sizeDif: ", sizeDif)
		get_window().position += Vector2i(sizeDif.x, 0)
		xShift += sizeDif.x
	expandedSizeUpdated.emit()







func switchSidesX():
	print("ui - switching sides X")
	var container = get_tree().get_first_node_in_group("xAxisBox")
	var dialogueBox = container.get_node("DialogueBox")
	xShift = (dialogueBox.get_rect().size.x)
	if xAlignment == "right":
		container.move_child(dialogueBox, 0)
		xAlignment = "left"
		xShift *= -1
	else:
		container.move_child(dialogueBox, -1)
		xAlignment = "right"
	get_window().position += Vector2i(xShift, 0)
	flippedXAxis.emit()





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
	get_tree().get_root().get_window().size = expandedSize
	get_tree().get_first_node_in_group("dialogueBox").visible = true
	if xAlignment == "left":
		get_window().position += Vector2i(xShift, 0)
	menuOpen = true

func hideMenu():
	print("hiding menu")
	get_window().size = shrunkenSize
	get_tree().get_first_node_in_group("dialogueBox").visible = false
	if xAlignment == "left":
		get_window().position -= Vector2i(xShift, 0)
	menuOpen = false





#func switchSidesY():
	#print("ui - switching sides Y")
	##%DraggableArea.vertical_alignment=shrink_end
	## Set tabs to bottom
	## set hotbar below 
	## reorder internals...



#func addToLastSaid(lastThingSaid):
	#if lastSaidStack.size() < 3:
		#lastSaidStack.append(lastThingSaid)
	#else:
		#lastSaidStack.pop_front()
		#lastSaidStack.append(lastThingSaid)


#func sayInMenu(toSay:String, duration:float = 0.0)->void:
	#%SpeechOutMenu.text = toSay
	#if duration > 0:
		#speaking = true
		#await get_tree().create_timer(duration).timeout
		#%SpeechOutMenu.clear()
		#speaking = false
