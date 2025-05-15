extends VBoxContainer

var snippets:Dictionary = {}
var snippetRowScene = preload("res://tabs/snippet_row.tscn")

const SAVE_SECTION = "SNIPS_TAB"


func _ready() -> void:
	snippets = Saver.loadGameSection(SAVE_SECTION, "snippets", snippets)
	#
	%NewSnippetButton.pressed.connect(openSnippetPad)
	%QuickSnippetButton.pressed.connect(quickSnip)
	%SnippetCancelButton.pressed.connect(closeSnippetPad)
	%SnippetSaveButton.pressed.connect(saveNewSnippet)
	#
	closeSnippetPad()
	refreshSnippetsList()


func quickSnip():
	var clipboardContent = DisplayServer.clipboard_get()
	if not clipboardContent: # if not a string in clipboard
		return
	var title = clipboardContent.left(18).strip_edges()
	snippets[title] = clipboardContent
	save()
	refreshSnippetsList()
	Globals.hideContextPopup($'.')


#Globals.hideContextPopup($'.')




func saveNewSnippet():
	print("code - editor input is: ", %CodeEditNode.text)
	snippets[%SnippetName.text] = %CodeEditNode.text
	save()
	refreshSnippetsList()
	closeSnippetPad()



func refreshSnippetsList():
	for c in %SnippetList.get_children():
		c.queue_free()
	for key in snippets.keys():
		var newRow = snippetRowScene.instantiate()
		newRow.setUp(key, snippets[key])
		newRow.editRequested.connect(editExistingSnippet)
		newRow.deleteRequested.connect(deleteExistingSnippet)
		%SnippetList.add_child(newRow)

func deleteExistingSnippet(snippetName:String):
	snippets.erase(snippetName)
	save()
	refreshSnippetsList()
	Globals.hideContextPopup($'.')

func editExistingSnippet(snippetName:String):
	openSnippetPad()
	%CodeEditNode.text = snippets[snippetName]
	%SnippetName.text = snippetName
	Globals.hideContextPopup($'.')


func openSnippetPad():
	%SnippetEditor.visible = true
	Globals.hideContextPopup($'.')

func closeSnippetPad():
	%SnippetEditor.visible = false
	%CodeEditNode.text = ""
	Globals.hideContextPopup($'.')


func save():
	Saver.saveGameSection(SAVE_SECTION, "snippets", snippets)





#func saveNewList():
	##print("todo - new list is: ", %TodoName.text)
	#todoLists[%Name.text] = {}
	#refreshListsList()
	#swapActiveList(%Name.text)
	#clearInputBar()
	#makingList = false
	#saveTodos()
	#%Name.text = ""
	#%Name.grab_focus()
#
#func saveNewTodo():
	##print("todo - new todo is: ", %Name.text)
	#todoLists[currentList][%Name.text] = false
	#clearInputBar()
	#refreshSnippetsList()
	#saveTodos()
	#%Name.text = ""
#
#func saveTodos():
	#Saver.saveGameSection(SAVE_SECTION, "todoLists", todoLists)
	#Saver.saveGameSection(SAVE_SECTION, "currentList", currentList)
	##print("todo - saved")
#
#func swapActiveList(newList:String):
	#currentList = newList
	#refreshTodoList()
	#saveTodos()
