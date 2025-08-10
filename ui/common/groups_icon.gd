extends VBoxContainer


#func _ready() -> void:
	#Groups.s_groupsUpdated.connect()

func setColorWithColors(colors:Array=[]):
	clearUnneededColorRects()
	if colors.size() == 0:
		$ColorRect.visible = false
		return
	var theColor = colors.pop_front()
	#print("group icon - firstColorGId: ", firstColorGId)
	if not theColor is Color or theColor == Color.WHITE:
		print("group icon - given non color: ", theColor)
		theColor = Color(theColor)
	$ColorRect.color = theColor
	for color in colors:
		var newColor = $ColorRect.duplicate()
		newColor.color = color
		$'.'.add_child(newColor)


func setColorsWithGroups(groupsIds:Array=[]):
	clearUnneededColorRects()
	if groupsIds.size() == 0:
		$ColorRect.visible = false
		return
	$ColorRect.visible = true
	var isFirstColor = true
	for gId in groupsIds:
		if isFirstColor:
			$ColorRect.color = Groups.getGroupColor(gId)
			isFirstColor = false
			continue
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
