extends PanelContainer



signal left_click
signal right_click

const SAVE_SECTION = "DIALOGUE_BOX"
var tabOrder:Dictionary = {
	"SNIPS_TAB":0,
	"TODO_TAB":1,
	"TIMER_TAB":2,
}
var lastActiveTab = 0


func _ready() -> void:
	tabOrder = Saver.loadGameSection(SAVE_SECTION, "tabOrder", tabOrder)
	lastActiveTab = Saver.loadGameSection(SAVE_SECTION, "lastActiveTab", lastActiveTab)
	%TabsContainer.current_tab = lastActiveTab
	gui_input.connect(onButtonGuiInput)
	Globals.dialogueBoxRef = $'.'
	%TabsContainer.tab_changed.connect(saveLastActiveTab)
	#%TabsContainer.active_tab_rearranged.connect(printTabs)


func jumpToList(tab, listName):
	print("box - jump to list: ", tab)
	#var tabsNum = %TabsContainer.get_tab_count()
	%TabsContainer.current_tab = tabOrder[tab]
	if tab == "TODO_TAB":
		$"MarginContainer/VBoxContainer/TabsContainer/To Do".swapActiveList(listName)
	UI.expandMenu()
	#for key in %TabsContainer:
		#print(key)



func saveLastActiveTab(tabIndex):
	Saver.saveGameSection(SAVE_SECTION, "lastActiveTab", tabIndex)


func getTabNodeByName(tabName):
	if tabName == "SNIPS_TAB":
		return %TabsContainer/Snips
	elif tabName == "TODO_TAB":
		return %"TabsContainer/To Do"
	elif tabName == "TIMER_TAB":
		return %TabsContainer/Snips

func getTabNumberByName(tabName):
	if tabName == "SNIPS_TAB":
		return %TabsContainer/Snips
	elif tabName == "TODO_TAB":
		return %"TabsContainer/To Do"
	elif tabName == "TIMER_TAB":
		return %TabsContainer/Snips

func printTabs(_g):
	for t in %TabsContainer.get_children():
		print(t.name)
	print("------")





func onButtonGuiInput(event=null):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
				Globals.hideContextButtonMenu($'.')
			MOUSE_BUTTON_RIGHT:
				#print("dialogue - hiding context popup")
				right_click.emit()
				Globals.hideContextButtonMenu($'.')







func handleChangeWidth(_valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(%WidthSlider.value, currentSize.y))

func handleChangeHeight(_valChanged):
	var currentSize = get_tree().get_root().get_window().size
	UI.handleWindowResize(Vector2(currentSize.x, %HeightSlider.value))






func flipHotbarButtonOrder():
	print("dialogue - flipping hotbar")
	var i = -1
	for c in %Hotbar.get_children():
		%Hotbar.move_child(c, i)
		i -= 1
	if UI.xAlignment == "right":
		%Hotbar.set_anchors_preset(Control.PRESET_CENTER_LEFT)
		%Hotbar.size_flags_horizontal = SIZE_SHRINK_BEGIN
	else:
		%Hotbar.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		%Hotbar.size_flags_horizontal = SIZE_SHRINK_END
