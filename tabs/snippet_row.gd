extends PanelContainer



signal editRequested(snippetName:String)
signal deleteRequested(snippetName:String)

var title:String

func setUp(snippetName:String, snippetContent:String):
	title = snippetName
	$HBoxContainer/Title.text = title
	$HBoxContainer/Title.tooltip_text = snippetContent.left(100)
	$HBoxContainer/Title.pressed.connect(func():DisplayServer.clipboard_set(snippetContent))
	$HBoxContainer/Edit.pressed.connect(func():editRequested.emit(title))
	$HBoxContainer/Delete.pressed.connect(func():deleteRequested.emit(title))
