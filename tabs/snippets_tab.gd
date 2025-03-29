extends VBoxContainer

var snippets:Dictionary = {}
var snippetRowScene = preload("res://tabs/snippet_row.tscn")

const SAVE_SECTION = "code_tab"


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
	saveSnippets()
	refreshSnippetsList()



func saveNewSnippet():
	print("code - editor input is: ", %CodeEditNode.text)
	snippets[%SnippetName.text] = %CodeEditNode.text
	saveSnippets()
	refreshSnippetsList()
	closeSnippetPad()

func saveSnippets():
	Saver.saveGameSection(SAVE_SECTION, "snippets", snippets)

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
	saveSnippets()
	refreshSnippetsList()

func editExistingSnippet(snippetName:String):
	openSnippetPad()
	%CodeEditNode.text = snippets[snippetName]
	%SnippetName.text = snippetName


func openSnippetPad():
	%SnippetEditor.visible = true

func closeSnippetPad():
	%SnippetEditor.visible = false
	%CodeEditNode.text = ""

#
