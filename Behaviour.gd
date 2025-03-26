extends Node

var lastState
var currentState
var nextState



# Snippy


# Called when the node enters the scene tree for the first time.
func _ready():
	#$"BehaviourTimer".timeout.connect(bored_hover)
	#$"..".doubleClicked.connect(tellJoke)
	pass
	#$"BehaviourTimer".timeout.connect(bored)
	


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


func bored():
	print("I'm bored..")
	#await %UI.sayInMenu("I'm bored...", 1.5)
	await %UI.sayInMenu("Hyrdate :)", 1.5)
	#%SpeechBox.visible = true
	#%Speech.text = "I'm bored..."

func tellJoke_fromResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json["name"])
	print(result)
	print(response_code)
	print(headers)
	print(body.get_string_from_utf8())
	await %UI.sayInMenu(json["setup"], 7.0)
	await %UI.sayInMenu(str(json["punchline"], " \n", urlToBBcodeLink("Official Joke API", "official-joke-api.appspot.com")), 30.0)
	
	return json

func tellJoke():
	$HTTPRequest.request_completed.connect(tellJoke_fromResponse)
	$HTTPRequest.request("https://official-joke-api.appspot.com/random_joke")

func urlToBBcodeLink( text:String, url:String):
	return str("[url=", url, "]", text, "[/url]")
