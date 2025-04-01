extends Node

signal hotbarShortcutAdded(tab, listName)
#signal hotbarShortcutPressed(tab, listName)
#signal deleteHotbarShortcut(title, isHotbar)
signal deleteSublist(tab, title)
signal deleteHotbarShortcut(title)
signal contextMenuClosed

var dialogueBoxRef
var hotbarRef
var contextMenuRef
var contextMenuIsOpen = false
var callerButton


func _ready() -> void:
	if not contextMenuRef:
		return





func addToHotbar(tabName, list):
	print("globals - addToHotbar: ", tabName, ", ", list)
	hotbarRef.makeHotbarShortcut(tabName, list)




func positionContextPopup():
	if not callerButton or not "contextIsOpen" in callerButton:
		return
	#print("globals - positionContextPopup: ", positionContextPopup)
	#contextMenuRef.global_position = callerButton.global_position + Vector2(25,25)
	contextMenuRef.global_position = get_viewport().get_mouse_position() + Vector2(10,10)


func toggleContextMenu(clickedNode, tab, list):
	#print("globals - about to toggle context menu, visible = : ", contextMenuIsOpen)
	if "contextIsOpen" in clickedNode:
		if clickedNode == callerButton:
			if not contextMenuIsOpen:
				showContextMenu(clickedNode, tab, list)
			else:
				hideContextPopup(clickedNode)
		else:
			showContextMenu(clickedNode, tab, list)
	#print("globals - toggling context menu, visible = : ", contextMenuIsOpen)

func hideContextPopup(clickedNode):
	contextMenuRef.visible = false
	contextMenuIsOpen = false
	if "contextIsOpen" in clickedNode:
		clickedNode.contextIsOpen = false

func showContextMenu(clickedNode, tab, listName):
	if not contextMenuRef:
		return
	callerButton = clickedNode
	positionContextPopup()
	print("globals - showing context menu: ", clickedNode,", ", tab, ", ", listName)
	contextMenuRef.visible = true
	contextMenuIsOpen = true
	contextMenuRef.setUp(tab, listName)
	if "contextIsOpen" in clickedNode:
		clickedNode.contextIsOpen = true
		
