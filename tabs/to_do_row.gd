extends PanelContainer

signal todoToggled(title, isComplete:bool)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)

var title:String
var isComplete:bool = false

func setUp(todoName:String, completed:bool):
	title = todoName
	%Strike.visible = false
	$HBoxContainer/Title.button_pressed = completed
	$HBoxContainer/Title.text = title
	$HBoxContainer/Title.toggled.connect(updateCompletedStatusStyles)
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit($HBoxContainer/Title.text))
	UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	updateCompletedStatusStyles(completed)


func setStrikeDimension():
	#print("todo row -  %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/newActiveTawTitle.get_rect().size)
	var buttonSize = $HBoxContainer/Title.get_rect().size
	var extraOffset = buttonSize * 0.2
	%Strike.points[1] = buttonSize + extraOffset

func updateCompletedStatusStyles(completed:bool):
	isComplete = completed
	if isComplete:
		var t = Timer.new()
		t.wait_time = 0.1
		t.autostart = true
		t.one_shot = true
		t.timeout.connect(makeStrikeVisible)
		$'.'.add_child(t)
	else:
		%Strike.visible = false
	todoToggled.emit(title, $HBoxContainer/Title.button_pressed)

func makeStrikeVisible():
	setStrikeDimension()
	%Strike.visible = true
