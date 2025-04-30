extends Node


var menuOpen = false

const defaultSize = Vector2(200, 140)
var shrunkenSizeYBuffer = 50
var shrunkenSize:Vector2 = defaultSize
var expandedSize:Vector2 = Vector2(800, 800)




var alwaysOnTop = false

var xAlignment = "right"
var xShift = 0


signal changedScreenCorner(newCorner)
signal toggledAlwaysOnTop(onOrOff)
signal flippedXAxis
signal expandedSizeUpdated
signal loaded
signal newActiveTab(newActiveTab:String)

const SAVE_SECTION = "ui"



func _ready():
	loadPreferences()
	changedScreenCorner.connect(handleCornerChange) # Drag area moves out from under mouse... :/ .. could warp mouse??
	#handleChangeShrunkenHeight(50) # not loaded pref











func handleChangeShrunkenHeight(newYBufferSize):
	print("ui - new y buffer: ", newYBufferSize)
	shrunkenSizeYBuffer = newYBufferSize
	setShrunkenSize()
	if menuOpen == false:
		get_window().size = shrunkenSize
	savePreferences()

func setShrunkenSize():
	shrunkenSize.y = defaultSize.y + shrunkenSizeYBuffer




func handleWindowResize(newSize:Vector2):
	var sizeDif = expandedSize - newSize
	expandedSize = newSize
	get_window().size = expandedSize
	if xAlignment == "left":
		#print("box - sizeDif: ", sizeDif)
		get_window().position += Vector2i(sizeDif.x, 0)
		xShift += sizeDif.x
	expandedSizeUpdated.emit()
	savePreferences()





func handleCornerChange(newCorner):
	if newCorner.x == 0 and xAlignment == "left":
		switchSidesX()
	elif newCorner.x == 1 and xAlignment == "right":
		switchSidesX()

func switchSidesX():
	#print("ui - switching sides X")
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






func setAlwaysOnTop(on:bool=false): 
	#print("ui - always on top: ", on)
	alwaysOnTop = on
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, alwaysOnTop)
	toggledAlwaysOnTop.emit(alwaysOnTop)





func toggleMenu():
	if menuOpen: hideMenu()
	else: expandMenu()

func expandMenu():
	if menuOpen:
		return
	get_tree().get_root().get_window().size = expandedSize
	get_tree().get_first_node_in_group("dialogueBox").visible = true
	if xAlignment == "left":
		get_window().position += Vector2i(xShift, 0)
	menuOpen = true

func hideMenu():
	if not menuOpen:
		return
	#print("hiding menu")
	get_window().size = shrunkenSize
	get_tree().get_first_node_in_group("dialogueBox").visible = false
	if xAlignment == "left":
		get_window().position -= Vector2i(xShift, 0)
	menuOpen = false




func loadPreferences():
	expandedSize = Saver.loadGameSection(SAVE_SECTION, "expandedSize", expandedSize)
	shrunkenSizeYBuffer = Saver.loadGameSection(SAVE_SECTION, "shrunkenSizeYBuffer", shrunkenSizeYBuffer)
	xAlignment = Saver.loadGameSection(SAVE_SECTION, "xAlignment", xAlignment)
	setShrunkenSize()
	loaded.emit()
	print("ui - loaded")

func savePreferences():
	Saver.setValForBatchSave(SAVE_SECTION, "expandedSize", expandedSize)
	Saver.setValForBatchSave(SAVE_SECTION, "shrunkenSizeYBuffer", shrunkenSizeYBuffer)
	Saver.setValForBatchSave(SAVE_SECTION, "xAlignment", xAlignment)
	Saver.saveBatch()
	print("ui - saved")



#func switchSidesY():
	#print("ui - switching sides Y")
	##%DraggableArea.vertical_alignment=shrink_end
	## Set tabs to bottom
	## set hotbar below 
	## reorder internals...
