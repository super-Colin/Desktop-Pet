extends PanelContainer

signal toggled(isComplete:bool)
signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)

var title:String
var isComplete:bool = false

func setUp(todoName:String, completed:bool):
	title = todoName
	$HBoxContainer/Title.text = title
	$HBoxContainer/Title.toggled.connect(updateCompletedStatusStyles)
	#$HBoxContainer/Edit.pressed.connect(func():editRequested.emit($HBoxContainer/Title.text))
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit($HBoxContainer/Title.text))
	UI.expandedSizeUpdated.connect(setStrikeDimension, CONNECT_DEFERRED)
	updateCompletedStatusStyles(completed)
	#setStrikeDimension()


func setStrikeDimension():
	print("todo row - %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/Title.get_rect().size)
	var buttonSize = $HBoxContainer/Title.get_rect().size
	var extraOffset = buttonSize * 0.2
	#%Strike.points[0] -= extraOffset
	%Strike.points[1] = buttonSize + extraOffset
	print("todo row - %Strike.points[1]: ", %Strike.points[1], ", ", $HBoxContainer/Title.get_rect().size)

func updateCompletedStatusStyles(completed:bool):
	isComplete = completed
	if isComplete:
		$HBoxContainer/Title.text = title
		setStrikeDimension()
		%Strike.visible = true
		#print("todo row - adding [ s]")
		#$HBoxContainer/Title/RichTextLabel.text = ""
		#$HBoxContainer/Title/RichTextLabel.append_text("[s]" + title + "[/s]")
		##$HBoxContainer/Title/RichTextLabel.bb_code_text = "[s]" + title + "[/s]"
	else:
		$HBoxContainer/Title/RichTextLabel.text = title
		%Strike.visible = false
	toggled.emit($HBoxContainer/Title.button_pressed)
