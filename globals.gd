extends Node

signal hotbarShortcutAdded(tab, listName)
#signal hotbarShortcutPressed(tab, listName)
#signal deleteHotbarShortcut(title, isHotbar)
signal deleteList(tab, list)
signal deleteSublist(tab, title, sublist)
signal deleteHotbarShortcut(title)
signal contextMenuClosed
signal verifyHotbarShortcut(tab, title)

signal closeProgramRequested

var dialogueBoxRef
var hotbarRef

var contextMenuRef
var contextMenuIsOpen = false
var contextMenuCallerButton


enum TabTypes {TODOS, SNIPPETS, TIMERS, IMAGES, GROUPS, SETTINGS}
enum GroupTypes {PROJECT, TASK, CATEGORY, OTHER}
#enum GroupTagTypes {NOTES, COPYPASTE, ONGOING, OTHER}
enum HotbarTypes {TAB, ROW, COPYPASTE, OTHER}



func _ready() -> void:
	if not contextMenuRef:
		return



# venn diagram icon for grouping


func addToHotbar(tabName, list):
	print("globals - addToHotbar: ", tabName, ", ", list)
	hotbarRef.makeHotbarShortcut(tabName, list)




func positionContextPopup():
	if not contextMenuCallerButton or not "contextIsOpen" in contextMenuCallerButton:
		return
	#print("globals - positionContextPopup: ", positionContextPopup)
	contextMenuRef.global_position = get_viewport().get_mouse_position() + Vector2(10,10)


#func toggleContextMenu(clickedNode, tab, list, isShortcut = false):
	##print("globals - about to toggle context menu, visible = : ", contextMenuIsOpen)
	#if "contextIsOpen" in clickedNode:
		#if clickedNode == callerButton:
			#if not contextMenuIsOpen:
				#showContextMenu(clickedNode, tab, list, isShortcut)
			#else:
				#hideContextPopup(clickedNode)
		#else:
			#showContextMenu(clickedNode, tab, list, isShortcut)
	##print("globals - toggling context menu, visible = : ", contextMenuIsOpen)
func toggleContextButtonMenu(clickedNode):
	#print("globals - about to toggle context menu, visible = : ", contextMenuIsOpen)
	if "contextIsOpen" in clickedNode:
		if clickedNode == contextMenuCallerButton:
			if not contextMenuIsOpen:
				showContextButtonMenu(clickedNode)
			else:
				hideContextButtonMenu(clickedNode)
		else:
			showContextButtonMenu(clickedNode)
	#print("globals - toggling context menu, visible = : ", contextMenuIsOpen)

func hideContextButtonMenu(clickedNode=null):
	if not contextMenuRef:
		return
	contextMenuRef.visible = false
	contextMenuIsOpen = false
	if clickedNode and "contextIsOpen" in clickedNode:
		clickedNode.contextIsOpen = false

func showContextButtonMenu(clickedNode):
	if not contextMenuRef:
		return
	contextMenuCallerButton = clickedNode
	positionContextPopup()
	#print("globals - showing context menu: ", clickedNode,", ", tab, ", ", listName)
	contextMenuIsOpen = true
	#contextMenuRef.setUp(tab, listName, isShortcut)
	contextMenuRef.setUp(clickedNode.buttonData)
	contextMenuRef.visible = false
	contextMenuRef.call_deferred("set_visible", true)
	if "contextIsOpen" in clickedNode:
		clickedNode.contextIsOpen = true

func contextMenuTriggeredDelete():
	if "emitDeleteRequest" in contextMenuCallerButton:
		contextMenuCallerButton.emitDeleteRequest()
		hideContextButtonMenu(contextMenuCallerButton)


func contextMenuTriggeredDuplicateList():
	if "emitDuplicateRequest" in contextMenuCallerButton:
		contextMenuCallerButton.emitDuplicateRequest()
		hideContextButtonMenu(contextMenuCallerButton)



func contextMenuTriggeredCopy():
	if "emitCopyRequest" in contextMenuCallerButton:
		contextMenuCallerButton.emitCopyRequest()
		hideContextButtonMenu(contextMenuCallerButton)


func contextMenuTriggeredEdit():
	if "emitEditRequest" in contextMenuCallerButton:
		contextMenuCallerButton.emitEditRequest()
		hideContextButtonMenu(contextMenuCallerButton)





func customCapitalize(input:String)->String:
	var output:String = ""
	for word in input.split(" "):
		output += word.left(1).to_upper() + word.erase(0,1) + " "
	return output.rstrip(" ")





#
