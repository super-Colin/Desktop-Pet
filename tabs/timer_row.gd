extends PanelContainer







signal timerToggled(title, isComplete:bool)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)

var title:String
var isComplete:bool = false

func setUp(todoName:String, completed:bool):
	title = todoName
	%Strike.visible = false
	$HBoxContainer/Title.button_pressed = completed
	$HBoxContainer/Title.text = title
	#$HBoxContainer/Title.toggled.connect(updateCompletedStatusStyles)
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit($HBoxContainer/Title.text))
	#UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	#updateCompletedStatusStyles(completed)


#func _physics_process(delta: float) -> void:
	#if not activeTab:
		#return
