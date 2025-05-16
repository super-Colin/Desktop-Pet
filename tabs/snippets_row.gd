extends RowTemplate




var dataDefault = {
	content="",
}


func setUp(name:String, setupData:Dictionary, tab:String):
	title = name
	if setupData == {}: # if no saved data
		data = dataDefault
		requestSave() # save the default data
	else: data = setupData
	%TitleButton.text = title
	%TitleButton.tooltip_text = data.content.replace("\n\n+", "\n").left(100)
	%TitleButton.pressed.connect(func():DisplayServer.clipboard_set(data.content))












#
