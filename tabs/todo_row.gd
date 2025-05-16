extends RowTemplate


# REQUIRED:
var dataDefault = {
	"done":false
}


func setUp(name:String, setupData:Dictionary, tab:String):
	title = name
	if setupData == {}: # if no saved data
		data = dataDefault
		requestSave() # save the default data
	else: data = setupData
	%Strike.visible = data.done
	UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	UI.expanedDialogueBox.connect(setStrikeDimension, CONNECT_DEFERRED)
	%TitleButton.setUp(tab, title)
	%TitleButton.pressed.connect(rowToggled)

func _readyHook():
	setStrikeDimension()

func rowToggled():
	data.done = not data.done
	if data.done:
		setStrikeDimension()
		makeStrikeVisible()
	else:
		%Strike.visible = false
	#todoToggled.emit(title)
	updated.emit(title, data)
	saveRequested.emit()

func makeStrikeVisible():
	#print("todo row - making strike visible")
	#get_tree().create_timer(0.15).timeout.connect(setStrikeDimension)
	%Strike.visible = true

func setStrikeDimension():
	#print("todo row -  %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/newActiveTawTitle.get_rect().size)
	await get_tree().create_timer(0.05).timeout
	var buttonSize = %TitleButton.get_rect().size
	var extraOffset = buttonSize * 0.2
	%Strike.points[1] = buttonSize + extraOffset




#
