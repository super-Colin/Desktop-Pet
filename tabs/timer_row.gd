extends PanelContainer


signal timerToggled(title:String, toggledOn:bool)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)

var title:String
var timing = false
var time = 0.0


func _ready() -> void:
	%Title.pressed.connect(toggleIsTiming)
	%TimerLabelButton.pressed.connect(toggleIsTiming)
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit(%Title.text))



func setUp(name:String, currentTime:float):
	title = name
	%Title.text = title
	%TimerLabelButton.text =  str(currentTime)


func roundDecimalPoints(num, decimalsPlaces=2):
	return "%0.2f" % time


func toggleIsTiming():
	print("timer row - toggling timing: ", %Title.text)
	timing = not timing



func _physics_process(delta: float) -> void:
	#print("timer row - is physics: ",)
	if timing:
		time += delta
		#print("timer row - is timing: ",)
		%TimerLabelButton.text = roundDecimalPoints(time)
