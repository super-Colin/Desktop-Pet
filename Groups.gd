extends Node

const exampleGroup = {
	#"id": "",
	"name": "Example Group",
	"color": Color.WHITE,
	"highlighted": false,
	"hidden": false,
	"onlyActive": false,
}

signal s_groupsUpdated


var savedGroups:Dictionary = {}
var highlightedGroups:Array = []
var hiddenGroups:Array = []
var onlyGroupActive:bool = false
var onlyGroup:String = ""


const SAVE_SECTION = "GROUPS"

func _ready() -> void:
	savedGroups = Saver.loadGameSection(SAVE_SECTION, "groups", savedGroups)
	for gId in savedGroups.keys():
		if savedGroups[gId].highlighted:
			highlightedGroups.append(gId)
		elif savedGroups[gId].hidden:
			hiddenGroups.append(gId)
		if savedGroups[gId].onlyActive:
			onlyGroupActive = true
			onlyGroup = gId


func deleteGroup(groupId):
	savedGroups.erase(groupId)
	s_groupsUpdated.emit()


func getGroupColor(groupId)->Color:
	#print("GROUPS - color for group: ", groupId, " is: ", savedGroups[groupId].color)
	if not savedGroups.has(groupId):
		return Color.WHITE
	return savedGroups[groupId].color


func getGroupsAsArray()->Array:
	var groups = []
	for gId in savedGroups.keys():
		groups.append(savedGroups[gId])
	return groups

func saveGroup(groupDict:Dictionary)->bool:
	var validatedGroup = validateNewGroup(groupDict)
	if not validatedGroup:
		return false
	#if savedGroups.has(validatedGroup.id):
		#print("Groups - updating an existing group from: ", savedGroups[validatedGroup.id], " to ", validatedGroup.name)
	savedGroups[validatedGroup.id] = validatedGroup
	#print("Groups - saving group: ", groupDict)
	Saver.saveGameSection(SAVE_SECTION, "groups", savedGroups)
	#updateGroups()
	return true


func updateGroups():
	s_groupsUpdated.emit()



func validateNewGroup(newGroupDict:Dictionary):
	if not newGroupDict.has("name") or newGroupDict.name == "":
		return false
	for key in exampleGroup.keys():
		if not newGroupDict.has(key):
			newGroupDict[key] = exampleGroup[key]
	if not newGroupDict.has("id"):
		#newGroupDict.id = randi() % 10000000000
		newGroupDict.id = randi()
	return newGroupDict





func getGroupNames():
	var names = []
	for g in savedGroups:
		names.append(g.name)
	return names


#
