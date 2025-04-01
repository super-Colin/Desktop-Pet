extends Container

var buttonScene = preload("res://context_button.tscn")

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
	Globals.deleteHotbarShortcut.connect(deleteShortcut)
	UI.loaded.connect(setSlidersFromSave)
	setSlidersFromSave()
	refreshHotbarList()

#func deleteShortcut(tab, shortcutName):
func deleteShortcut(shortcutName):
	#print("hotbar - deleting : ", shortcutName, ", is shortcut: ", tab)
	#if not tab == "HOTBAR":
		#print("hotbar - actually NOT deleting : ", shortcutName)
		#return
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






func makeHotbarShortcut(tabName, listName):
	if not listName in hotbarList.keys():
		hotbarList[listName] = {"tabName":tabName, "listName": listName}
		Saver.saveGameSection(SAVE_SECTION, "hotbar", hotbarList)
	print("hotbar - making shortcut: ", tabName, ", listName: ", listName)
	var newButton = buttonScene.instantiate()
	newButton.setUp(tabName, listName, true)
	newButton.pressed.connect(func(): shortcutPressed.emit(tabName, listName))
	%Shortcuts.add_child(newButton)








func handleChangeShrunkenHeight(valChanged):
	UI.handleChangeShrunkenHeight(%ShrunkenHeightSlider.value)

func handleChangeWidth(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))

func setSlidersFromSave():
	var currentSize = get_tree().get_root().get_window().size
	%ShrunkenHeightSlider.value = UI.shrunkenSizeYBuffer
	%WidthSlider.value = UI.expandedSize.x
	%HeightSlider.value = UI.expandedSize.y
	print("hotbar - set sliders, ", UI.shrunkenSizeYBuffer, ", " , currentSize)
