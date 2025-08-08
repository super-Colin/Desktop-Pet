extends VBoxContainer


#func _ready() -> void:
	#Groups.s_groupsUpdated.connect()

func setColorsWithGroups(groupsIds:Array=[]):
	clearUnneededColorRects()
	if groupsIds.size() == 0:
		$ColorRect.visible = false
		return
	# remove first color from array to always keep 
	var firstColorGId = groupsIds.pop_front()
	$ColorRect.color = Groups.getGroupColor(firstColorGId)
	for gId in groupsIds:
		var newColor = $ColorRect.duplicate()
		newColor.color = Groups.getGroupColor(gId)
		$'.'.add_child(newColor)

func clearUnneededColorRects(totalNeeded=1):
	var i = 0
	for c in $'.'.get_children():
		i += 1
		if i == 1:
			continue
		if i > totalNeeded:
			c.queue_free()





#
