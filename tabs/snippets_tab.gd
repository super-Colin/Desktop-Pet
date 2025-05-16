extends TabTemplate


#func _ready() -> void:
	#super._ready()

func _readyHook():
	%QuickSnipButton.pressed.connect(quickSnip)
	%EditorSaveButton.pressed.connect(saveEdit)
	%EditorCancelButton.pressed.connect(clearEditor)

func quickSnip():
	var clipboardContent = DisplayServer.clipboard_get()
	if not clipboardContent: # if not a string in clipboard
		print("snippets tab - nothing in clipboard: ", clipboardContent)
		return
	var title = clipboardContent.left(18).strip_edges()
	#snippets[title] = clipboardContent
	saveNewRow(inputsToRowData(), title)
	#Globals.hideContextPopup($'.')

func makeNewRowHook(rowScene):
	#print("snip tab - hooked into new row")
	rowScene.editRequested.connect(editSnippet)

var editingRow = ""

func editSnippet(title, data):
	#print("snip tab - editing row")
	editingRow = title
	showEditor()
	%EditorNameInput.text = title
	%CodeEditNode.text = data.content
	#saveEdit(title, data)
	#editRequested

func saveEdit():
	if %CodeEditNode.text == "":
		print("snip tab - editor node has no input")
		return
	if editingRow == %EditorNameInput.text:
		print("snip tab - updating item in place")
		updateItemData(editingRow, inputsToRowData(), currentList)
		refreshList()
	else:
		print("snip tab - saving new")
		deleteListItem(editingRow)
		saveNewRow(inputsToRowData(), %EditorNameInput.text)
	#editingRow = ""
	clearEditor()
	hideEditor()


func inputsToRowData():
	return {
		"content":%CodeEditNode.text
	}


#region Make New / Duplicate
#func makeNewRow(rowKey):
	#var newRow = rowScene.instantiate()
	#newRow.setUp(rowKey, lists[currentList][rowKey])
	##newRow.todoToggled.connect(todoToggled)
	#return newRow
func clearEditor():
	%EditorNameInput.text = ""
	%CodeEditNode.text = ""
	editingRow = ""

#endregion


#region Saving
#func saveNewRow(data):
	##print("todo - new todo is: ", %NameInput.text)
	#var capitalized = Globals.customCapitalize(%NameInput.text)
	#lists[currentList][capitalized] = data
	#cleanInputBar()
	#refreshList()
	#saveTab()
	#%NameInput.text = ""

#endregion



#
