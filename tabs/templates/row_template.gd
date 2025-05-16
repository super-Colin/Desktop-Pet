extends PanelContainer
class_name RowTemplate

signal editRequested(itemName:String, data:Dictionary)
signal deleteRequested(itemName:String)
signal updated(itemName:String, data:Dictionary)
signal saveRequested

var title:String
#var timing = false # temporary vars


var data:Dictionary = {
	#time = 0.0 # vars that should be saved
}

# REQUIRED:
#var dataDefault = {}
#func setUp(name:String, setupData:Dictionary):
	#title = name
	#if setupData == {}: # if no saved data
		#data = dataDefault
		#requestSave() # save the default data
	#else: data = setupData


@export var showResetButton:bool = false
@export var showEditButton:bool = false
@export var showDeleteButton:bool = true


func _ready() -> void:
	%EditButton.pressed.connect(func():editRequested.emit(title, data))
	%DeleteButton.pressed.connect(func():deleteRequested.emit(title))
	if not showResetButton: %ResetButton.visible = false
	#%ResetButton.pressed.connect(func():deleteRequested.emit(title))
	if not showEditButton: %EditButton.visible = false
	if not showDeleteButton: %DeleteButton.visible = false
	





# REQUIRED:
#var dataDefault = {}
#func setUp(name:String, setupData:Dictionary):
	#title = name
	#if setupData == {}: # if no saved data
		#data = dataDefault
		#requestSave() # save the default data
	#else: data = setupData









func requestSave():
	updated.emit(title, data)
	saveRequested.emit()



#
