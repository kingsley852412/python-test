extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var code_input: TextEdit = $TextEdit
	var result_output: Label = $OutputLabel
	
	var temp_file_path = "user://temp_code.py"
	var file = FileAccess.open(temp_file_path, FileAccess.WRITE)
	if file:
		file.store_string(code_input.text)
		file.close()
	else:
		result_output.text = "Error: Failed to write code file."
		return

	# 2. Get the global absolute path of the temporary script
	var global_script_path = ProjectSettings.globalize_path(temp_file_path)
	
	# 3. LOCATE PYTHON (Works both in the Editor and after Exporting)
	var python_exe_path: String
	
	if OS.has_feature("editor"):
		# If running inside the Godot Editor
		python_exe_path = ProjectSettings.globalize_path("res://pythoncore-3.12-64/python.exe")
	else:
		# If running as an exported standalone game (.exe)
		# OS.get_executable_path().get_base_dir() points to the folder containing your game.exe
		var game_folder = OS.get_executable_path().get_base_dir()
		python_exe_path = game_folder.path_join("pythoncore-3.12-64/python.exe")
	
	
	# 4. Execute the bundled Python
	var output = []
	var exit_code = OS.execute(python_exe_path, [global_script_path], output, true)
	
	# 5. Display the output
	if exit_code == 0:
		result_output.text = output[0] if output.size() > 0 else "Success (No output)."
	else:
		result_output.text = "Python Error:\n" + (output[0] if output.size() > 0 else "Unknown error.")
