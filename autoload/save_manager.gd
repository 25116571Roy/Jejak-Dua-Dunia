extends Node

var save_file_path: String = "user://save_game.dat"

func save_game(data: Dictionary) -> bool:
	var file := FileAccess.open(save_file_path, FileAccess.WRITE)
	if not file:
		return false
	
	var json_string := JSON.stringify(data)
	file.store_string(json_string)
	file.close()
	return true

func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_file_path):
		return {}
	
	var file := FileAccess.open(save_file_path, FileAccess.READ)
	if not file:
		return {}
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	
	if parse_result != OK:
		return {}
	
	return json.data

func save_settings(settings: Dictionary) -> bool:
	var settings_path := "user://settings.dat"
	var file := FileAccess.open(settings_path, FileAccess.WRITE)
	if not file:
		return false
	
	var json_string := JSON.stringify(settings)
	file.store_string(json_string)
	file.close()
	return true

func load_settings() -> Dictionary:
	var settings_path := "user://settings.dat"
	
	if not FileAccess.file_exists(settings_path):
		return _get_default_settings()
	
	var file := FileAccess.open(settings_path, FileAccess.READ)
	if not file:
		return _get_default_settings()
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_result := json.parse(json_string)
	
	if parse_result != OK:
		return _get_default_settings()
	
	return json.data

func _get_default_settings() -> Dictionary:
	return {
		"music_volume": 0.8,
		"sfx_volume": 0.8,
		"voice_volume": 0.8,
		"ui_volume": 0.8,
		"fullscreen": false,
		"vsync": true
	}

func delete_save() -> void:
	if FileAccess.file_exists(save_file_path):
		DirAccess.remove_absolute(save_file_path)
