extends Button


@export var canBeHotbarShortcut = false
@export var canBeDuplicated = false
@export var canBeCopied = false
@export var canBeDeleted = false
@export var canBeEdited = false
@export var editableInPlace = false
@export var editingWhenLoaded = false
@export var editableColor = false
@export var canBeGrouped = false
@export var groupTypes:Array[Globals.GroupTypes] = []



var buttonData:Dictionary = {
	tabName="",
	name="",
	color=Color.WHITE,
	isHotbarShortcut=false,
	groups = [],
	# Doing these here doesn't use the exported values
	## * as set in a loaded / instantiated scene *
	# Do them in _ready() instead
	#canBeHotbarShortcut = canBeHotbarShortcut,
	#editingWhenLoaded = editingWhenLoaded,
	#.....
	#canBeGrouped = canBeGrouped,
	#groupTypes = groupTypes,
}


signal left_click(nodeRef)
signal right_click(nodeRef)

signal s_deleteRequested()
signal s_editRequested()
signal s_editSubmitted(dataDict)
signal s_copyRequested(dataDict)
signal s_duplicateRequested(dataDict)

var title:String
var contextIsOpen:bool = false
var tabName
#var isHotbarShortcut:bool = false
#var groups:Array = []



func _ready() -> void:
	#$'.'.pressed.connect(func():Globals.toggleContextMenu($'.', tabName, title))
	if editingWhenLoaded:
		editInPlace()
	gui_input.connect(onButtonGuiInput)
	Globals.contextMenuClosed.connect(func():contextIsOpen = false)
	$EditInput/LineEdit.text_submitted.connect(func(_text):editSubmitted())
	$EditInput/SaveEditButton.pressed.connect(editSubmitted)
	buttonData.canBeHotbarShortcut = canBeHotbarShortcut
	buttonData.canBeDuplicated = canBeDuplicated
	buttonData.canBeDeleted = canBeDeleted
	buttonData.canBeEdited = canBeEdited
	buttonData.canBeCopied = canBeCopied
	buttonData.editableInPlace = editableInPlace
	buttonData.editableColor = editableColor
	buttonData.editingWhenLoaded = editingWhenLoaded
	buttonData.canBeGrouped = canBeGrouped
	buttonData.groupTypes = groupTypes






#@export var canBeHotbarShortcut = false
#@export var canBeDuplicated = false
#@export var canBeDeleted = false
#@export var canBeEdited = false
#@export var editableInPlace = false
#@export var editableColor = false
#@export var canBeGrouped = false
#@export var groupTypes:Array[Globals.GroupTypes] = []


func startEditingInPlace():
	editInPlace()
	$EditInput/LineEdit.grab_focus()

func editInPlace():
	print("button - editing in place: ", buttonData)
	if editableColor:
		$EditInput/ColorPickerButton.color = buttonData.color
		$EditInput/ColorPickerButton.visible = true
	$EditInput/LineEdit.placeholder_text = $'.'.text
	$EditInput/LineEdit.text = $'.'.text
	$'.'.text = ""
	$EditInput.visible = true
	#$EditInput/LineEdit.grab_focus()









func onButtonGuiInput(event=null):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
				#if contextIsOpen:
				Globals.hideContextButtonMenu($'.')
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
				#print("context button - ", $'.', ", ", tabName, ", ",title)
				#Globals.toggleContextMenu($'.', tabName, title, buttonData.isHotbarShortcut)
				Globals.toggleContextButtonMenu($'.')

#func setUp(tab, label, isShortcut = false):
func setup(newButtonData):
	#print("context button - set up; tab: ", tab, ", label: ", label, ", is shortcut: ", isShortcut)
	for key in newButtonData.keys():
		buttonData[key] = newButtonData[key]
	$'.'.text = buttonData.name
	#if not newButtonData.has("groups"):
		#buttonData.groups = buttonData
	$EditInput/ColorPickerButton.color = buttonData.color
	if buttonData.has("editingWhenLoaded") and buttonData.editingWhenLoaded:
		editInPlace()



func editSubmitted():
	print("button - edit submitted")
	$EditInput.visible = false
	if $EditInput/LineEdit.text == "":
		buttonData.name = $EditInput/LineEdit.placeholder_text
	else:
		buttonData.name = $EditInput/LineEdit.text
	$'.'.text = buttonData.name
	buttonData.color = $EditInput/ColorPickerButton.color
	s_editSubmitted.emit(buttonData)

# called from Global
func emitEditRequest():
	s_editRequested.emit()
func emitDeleteRequest():
	s_deleteRequested.emit()
func emitCopyRequest():
	s_copyRequested.emit(title)
func emitDuplicateRequest():
	s_duplicateRequested.emit(title)
