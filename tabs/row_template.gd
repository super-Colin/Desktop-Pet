extends PanelContainer
class_name RowTemplate

signal editRequested(itemName:String)
signal deleteRequested(itemName:String)
signal updated(itemName:String, data:Dictionary)
signal saveRequested

var title:String
#var timing = false


var data:Dictionary = {
	#time = 0.0
}


func requestSave():
	updated.emit(title, data)
	saveRequested.emit()
















#
