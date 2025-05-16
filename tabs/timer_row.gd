extends RowTemplate
#class_name TimerRow 

#Inherited:
#signal editRequested(itemName:String)
#signal deleteRequested(itemName:String)
#signal updated(itemName:String, data:Dictionary)
#signal saveRequested(itemName:String)
#
#var title:String
#var data = {}

var dataDefault = {
		"time":0.0
	}
var timing = false


func _ready() -> void:
	if data == {}:
		data = dataDefault
	#%Title.pressed.connect(toggleIsTiming)
	%TimerLabelButton.pressed.connect(toggleIsTiming)
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit(title))
	print("timer row - ready: ", data )
	pass




func setUp(name:String, setupData:Dictionary, tab:String):
	title = name
	if setupData == {}: # if no saved data
		data = dataDefault
		requestSave() # save the default data
	else: data = setupData
	#print("timer row - setupDic: ", setupData, ", ", data )
	#print("timer row - setupDic: ", setupData, ", ", data )
	%TimerLabelButton.text = title + "\n" + floatToTimeFormat(data.time)



func floatToTimeFormat(numOfSeconds):
	var seconds = fmod(numOfSeconds, 60)
	var minutes = int(numOfSeconds) / 60
	var hours = minutes / 60
	minutes %= 60
	return "%d : %d : %00.01f" % [hours, minutes, seconds]
	#return "%d : %d : %d" % [hours, minutes, seconds]


func toggleIsTiming():
	print("timer row - toggling timing: ", title)
	timing = not timing
	if not timing:
		requestSave()



var lastSavedSecond = 0
func _physics_process(delta: float) -> void:
	#print("timer row - is physics: ",)
	if timing:
		data.time += delta
		#print("timer row - is timing: ",)
		%TimerLabelButton.text = title + "\n" + floatToTimeFormat(data.time)
		if int(data.time) % 60 == 0 and lastSavedSecond != int(data.time):
			lastSavedSecond = int(data.time)
			requestSave()


func requestSave():
	updated.emit(title, data)
	saveRequested.emit()


#
