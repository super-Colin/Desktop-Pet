extends PanelContainer

signal todoToggled(title, isComplete:bool)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)



var title:String
var isComplete:bool = false

func setUp(todoName:String, completed:bool):
	title = todoName
	$Control/ContextPopup.visible = false
	%Strike.visible = false
	UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	$HBoxContainer/Title.pressed.connect(rowToggled)
	$HBoxContainer/Title.text = title






func rowToggled():
	isComplete = not isComplete
	if isComplete:
		todoToggled.emit(title)
		makeStrikeVisible()
	else:
		%Strike.visible = false


func makeStrikeVisible():
	print("todo row - making strike visible")
	setStrikeDimension()
	%Strike.visible = true

func setStrikeDimension():
	#print("todo row -  %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/newActiveTawTitle.get_rect().size)
	var buttonSize = $HBoxContainer/Title.get_rect().size
	var extraOffset = buttonSize * 0.2
	%Strike.points[1] = buttonSize + extraOffset

#func updateCompletedStatusStyles(completed:bool):
	#isComplete = completed
	#if isComplete:
		#var t = Timer.new()
		#t.wait_time = 0.1
		#t.autostart = true
		#t.one_shot = true
		#t.timeout.connect(makeStrikeVisible)
		#$'.'.add_child(t)
	#else:
		#%Strike.visible = false
	#todoToggled.emit(title, $HBoxContainer/Title.button_pressed)
