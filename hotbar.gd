extends Container

var buttonScene = preload("res://ui/common/context_button/context_button.tscn")

const SAVE_SECTION = "HOTBAR"
var hotbarList:Dictionary = {} # "MyTodoList":{"dishes":true}

signal shortcutPressed(tab, list)


func _ready() -> void:
	hotbarList = Saver.loadGameSection(SAVE_SECTION, "hotbarList", hotbarList)
	print("hotbar - loaded list: ", hotbarList)
	Globals.hotbarRef = $'.'
	%WidthSlider.drag_ended.connect(handleChangeWidth)
	%HeightSlider.drag_ended.connect(handleChangeHeight)
	%ShrunkenHeightSlider.drag_ended.connect(handleChangeShrunkenHeight)
	%AlwaysOnTopToggle.toggled.connect(UI.setAlwaysOnTop)
	%Sides.pressed.connect(UI.switchSidesX)
	%Close.pressed.connect(func(): Globals.closeProgramRequested.emit())
	Globals.deleteHotbarShortcut.connect(deleteShortcut)
	#Globals.verifyHotbarShortcut.connect(verifyShortcut)
	UI.loaded.connect(setSlidersFromSave)
	setSlidersFromSave()
	refreshHotbarList()
	gui_input.connect(onButtonGuiInput)





#func deleteShortcut(tab, shortcutName):
func deleteShortcut(shortcutName):
	if not shortcutName in hotbarList.keys():
		return
	hotbarList.erase(shortcutName)
	refreshHotbarList()
	saveHotbar()

func saveHotbar():
	Saver.saveGameSection(SAVE_SECTION, "hotbarList", hotbarList)

	#print("todo - saved")

func refreshHotbarList():
	#print("todo - ", todoLists[currentList])
	for c in %Shortcuts.get_children():
		c.queue_free()
	for key in hotbarList.keys():
		print("hotbar - list: ", hotbarList)
		#buttonScene.deleteRequested.connect(deleteTodo)
		#print("hotbar - added shortcut: ", newRow)
		makeHotbarShortcut(hotbarList[key].tabName, hotbarList[key].listName)

func onButtonGuiInput(event=null):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				#left_click.emit()
				Globals.hideContextPopup($'.')
			MOUSE_BUTTON_RIGHT:
				#right_click.emit()
				Globals.hideContextPopup($'.')


func makeHotbarShortcut(tabName, listName):
	if not listName in hotbarList.keys():
		hotbarList[listName] = {"tabName":tabName, "listName": listName}
		Saver.saveGameSection(SAVE_SECTION, "hotbar", hotbarList)
	#print("hotbar - making shortcut: ", tabName, ", listName: ", listName)
	var newButton = buttonScene.instantiate()
	newButton.setUp(tabName, listName, true)
	newButton.pressed.connect(func(): shortcutPressed.emit(tabName, listName))
	newButton.deleteRequested.connect(deleteShortcut)
	%Shortcuts.add_child(newButton)








func handleChangeShrunkenHeight(_valChanged):
	UI.handleChangeShrunkenHeight(%ShrunkenHeightSlider.value)

func handleChangeWidth(_valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(_valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))
	Globals.hideContextButtonMenu($'.')

func setSlidersFromSave():
	var currentSize = get_tree().get_root().get_window().size
	%ShrunkenHeightSlider.value = UI.shrunkenSizeYBuffer
	%WidthSlider.value = UI.expandedSize.x
	%HeightSlider.value = UI.expandedSize.y
	print("hotbar - set sliders, ", UI.shrunkenSizeYBuffer, ", " , currentSize)
