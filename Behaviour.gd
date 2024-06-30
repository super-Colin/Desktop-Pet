extends Node

var lastState
var currentState
var nextState






# Called when the node enters the scene tree for the first time.
func _ready():
	#$"BehaviourTimer".timeout.connect(bored_hover)
	$"BehaviourTimer".timeout.connect(bored_speak)
	$"..".doubleClicked.connect(tellJoke)
	pass # Replace with function body.


# "_process" calls are in main Pet script



func bored_hover():
	get_window().position += Vector2i(0, -50)
	await get_tree().create_timer(0.2).timeout
	get_window().position += Vector2i(-50, 0)
	await get_tree().create_timer(0.2).timeout
	get_window().position += Vector2i(100, 0)
	await get_tree().create_timer(0.2).timeout
	get_window().position += Vector2i(-50, 0)
	await get_tree().create_timer(0.2).timeout
	get_window().position += Vector2i(0, 50)


func bored_speak():
	print("I'm bored..")
	#%SpeechBox.visible = true
	#%Speech.text = "I'm bored..."

func tellJoke_fromResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json["name"])
	print(result)
	print(response_code)
	print(headers)
	print(body.get_string_from_utf8())
	await $"..".say(json["setup"])
	await $"..".say(json["punchline"])
	return json

func tellJoke():
	$HTTPRequest.request_completed.connect(tellJoke_fromResponse)
	#$HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases/latest")
	$HTTPRequest.request("https://official-joke-api.appspot.com/random_joke")
	return "hi"


