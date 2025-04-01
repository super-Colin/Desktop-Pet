extends PanelContainer

signal todoToggled(title)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)



var title:String
var tabName = "TODO_TAB"
var isComplete:bool = false


func setUp(todoName:String, completed:bool):
	title = todoName
	$HBoxContainer/Title.setUp(tabName, todoName)
	isComplete = completed
	#$Control/ContextPopup.visible = false
	if completed:
		makeStrikeVisible()
	else:
		%Strike.visible = false
	%Strike.visible = completed
	UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	$HBoxContainer/Title.pressed.connect(rowToggled)
	%Title.setUp(tabName, todoName)







func rowToggled():
	isComplete = not isComplete
	if isComplete:
		setStrikeDimension()
		makeStrikeVisible()
	else:
		%Strike.visible = false
	todoToggled.emit(title)


func makeStrikeVisible():
	#print("todo row - making strike visible")
	var t = Timer.new()
	t.wait_time = 0.1
	t.autostart = true
	t.one_shot = true
	t.timeout.connect(setStrikeDimension)
	%Strike.visible = true

func setStrikeDimension():
	#print("todo row -  %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/newActiveTawTitle.get_rect().size)
	var buttonSize = $HBoxContainer/Title.get_rect().size
	var extraOffset = buttonSize * 0.2
	%Strike.points[1] = buttonSize + extraOffset
