extends Node




var openContextMenuRef



func hideContextPopup():
	if not openContextMenuRef:
		return
	#openContextMenuRef.visible = false
	openContextMenuRef.hideContext()
