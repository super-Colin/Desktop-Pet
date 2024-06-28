extends Node2D







# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.get_config_dir())
	print(OS.get_connected_midi_inputs())
	print(OS.get_data_dir())
	#print(OS.get_environment())
	print(OS.get_executable_path())
	print(OS.get_granted_permissions())
	#print(OS.get_keycode_string())
	print(OS.get_model_name())
	print(OS.get_processor_count())
	print(OS.get_static_memory_peak_usage())
	print(OS.get_static_memory_usage())
	#print(OS.get_system_dir())
	print(OS.get_user_data_dir())
	print("------")
	print(OS.is_debug_build())
	print(OS.is_sandboxed())
	print(OS.is_userfs_persistent())
	print(OS.is_blocking_signals())
	print(OS.is_queued_for_deletion())
	#OS.shell_open("https://google.com")
	#OS.shell_open("C:/xampp/htdocs/zOverTherWire.flags.txt")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



