extends Node

signal saveLoaded
signal saved

@onready var saveGameConfigNode:ConfigFile = ConfigFile.new()

const SAVE_DIRECTORY_PATH = "user://"
const SAVE_FILE_TITLE = "config"
const SAVE_FILE_PATH = SAVE_DIRECTORY_PATH + SAVE_FILE_TITLE + ".cfg"


func _ready() -> void:
	initialLoad()


func initialLoad():
	var err = saveGameConfigNode.load(SAVE_FILE_PATH)
	if err != OK:
		print("saves - error loading save file: ", err, ", -- making new file --")
		await initNewSaveFile()
	else: print("saves - loaded save file successfully")
	saveLoaded.emit()
	return true


func setValForBatchSave(sectionName, sectionKey, sectionData):
	if saveGameConfigNode == null:print("saves - saveGameSection didn't have config var")
	saveGameConfigNode.set_value(sectionName, sectionKey, sectionData)
func saveBatch():
	saveGameConfigNode.save(SAVE_FILE_PATH)
	saved.emit()

func saveGameSection(sectionName, sectionKey, sectionData):
	if saveGameConfigNode == null:print("saves - saveGameSection didn't have config var")
	saveGameConfigNode.set_value(sectionName, sectionKey, sectionData)
	saveGameConfigNode.save(SAVE_FILE_PATH)
	saved.emit()


func loadGameSection(sectionName, sectionKey, fallback):
	return saveGameConfigNode.get_value(sectionName, sectionKey, fallback)


func initNewSaveFile():
	print("saves - initing new save")
	if ResourceLoader.exists(SAVE_FILE_PATH):
		var result = DirAccess.remove_absolute(SAVE_FILE_PATH)
		if result != 0:
			print("save - couldn't delete previous save file, code: ", result)
		else: print("save - deleted previous save file, code: ", result)
	saveGameConfigNode = ConfigFile.new()
	#reset_saveStates_all()


func save_to_file(fileName:String, fileContent:String, fileExtension:String=".txt", directory:String=""):
	var file = FileAccess.open("user://" + fileName + fileExtension, FileAccess.WRITE)
	file.store_string(fileContent)

func load_from_file(fileName:String, fileContent:String, fileExtension:String=".txt", directory:String="", isString:bool=true):
	var file = FileAccess.open("user://" + fileName + fileExtension, FileAccess.READ)
	var content = file.get_as_text()
	return content

#
#func saveGame_all():
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for node in save_nodes:
		#get_tree().call_group("save", "_save")
#
#func reset_saveStates_all():
	#get_tree().call_group("save", "_resetSaveState")
	#saveGame_all()
