extends Node

const exampleGroup = {
	#"id": "",
	"name": "Example Group",
	"color": Color.WHITE,
	"highlighted": false,
	"sortTop": false,
	"sortBottom": false,
	"onlyActive": false,
}

signal s_groupsUpdated
signal s_groupColorsUpdated
signal s_groupDeleted(groupId)


var savedGroups:Dictionary = {}
var highlightedGroups:Array = []
var sortTopGroups:Array = []
var sortBottomGroups:Array = []
var onlyGroupActive:bool = false
var onlyGroup:String = ""


const SAVE_SECTION = "GROUPS"


func toggleSortTop(groupId):
	#print("Groups - group sort top toggled: ", savedGroups[groupId].name)
	savedGroups[groupId].sortTop = ! savedGroups[groupId].sortTop
	if savedGroups[groupId].sortTop: savedGroups[groupId].sortBottom = false
	saveGroup(savedGroups[groupId])
	s_groupsUpdated.emit()

func toggleSortBottom(groupId):
	#print("Groups - group sort bottom toggled: ", savedGroups[groupId].name)
	savedGroups[groupId].sortBottom = ! savedGroups[groupId].sortBottom
	if savedGroups[groupId].sortBottom: savedGroups[groupId].sortTop = false
	saveGroup(savedGroups[groupId])
	s_groupsUpdated.emit()



func hasATopGroup(groupsIds:Array)->bool:
	for gId in groupsIds:
		if savedGroups[gId].sortTop:
			return true
	return false

func hasABottomGroup(groupsIds:Array)->bool:
	for gId in groupsIds:
		if savedGroups[gId].sortBottom:
			return true
	return false

func _ready() -> void:
	savedGroups = Saver.loadGameSection(SAVE_SECTION, "groups", savedGroups)
	for gId in savedGroups.keys():
		if savedGroups[gId].highlighted:
			highlightedGroups.append(gId)
		if savedGroups[gId].sortTop:
			sortTopGroups.append(gId)
		elif savedGroups[gId].sortBottom:
			sortBottomGroups.append(gId)
		#if savedGroups[gId].onlyActive:
			#onlyGroupActive = true
			#onlyGroup = gId


func deleteGroup(groupId):
	print("Groups - deleting group: ", groupId)
	savedGroups.erase(groupId)
	s_groupDeleted.emit(groupId)
	#call_deferred(func():s_groupsUpdated.emit())
	s_groupsUpdated.emit()


func getGroupIds():
	return savedGroups.keys()

func getGroupName(groupId, fallback:String=""):
	print(savedGroups)
	if not groupId:
		return fallback
	return savedGroups[groupId].name

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
	#s_groupsUpdated.emit()
	return true

func updateGroup(groupDict:Dictionary):
	print("Groups - updating: ", groupDict)
	var old = savedGroups[groupDict.id]
	saveGroup(groupDict)
	if old.name != groupDict.name:
		print("Groups - name updated")
		s_groupsUpdated.emit()
	elif old.color != groupDict.color:
		print("Groups - color updated")
		s_groupColorsUpdated.emit()

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



func getGroup(groupId):
	return savedGroups[groupId].duplicate()

func getGroupNames():
	var names = []
	for g in savedGroups:
		names.append(g.name)
	return names


#
