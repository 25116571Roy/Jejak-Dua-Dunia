extends Node

var volume_master: float = 0.8
var volume_sfx: float = 0.8
var volume_music: float = 0.8
var volume_voice: float = 0.5

const MAX_VOLUME = 1.0
const MIN_VOLUME = 0.0

var persistent_volume_settings = {
	"master": {"current": 0.8, "default": 0.8, "name": "Master"},
	"sfx": {"current": 0.8, "default": 0.8, "name": "SFX"},
	"music": {"current": 0.8, "default": 0.8, "name": "Music"},
	"voice": {"current": 0.5, "default": 0.5, "name": "Voice"}
}

func set_volume(bus_name: String, volume: float):
	if bus_name in persistent_volume_settings:
		persistent_volume_settings[bus_name].current = clamp(volume, MIN_VOLUME, MAX_VOLUME)
		_update_bus_volume(bus_name, volume)

func get_volume(bus_name: String) -> float:
	if bus_name in persistent_volume_settings:
		return persistent_volume_settings[bus_name].current
	return 0.0

func get_default_volume(bus_name: String) -> float:
	if bus_name in persistent_volume_settings:
		return persistent_volume_settings[bus_name].default
	return 0.0

func set_default_volume(bus_name: String):
	if bus_name in persistent_volume_settings:
		persistent_volume_settings[bus_name].current = persistent_volume_settings[bus_name].default
		_update_bus_volume(bus_name, persistent_volume_settings[bus_name].current)

func _update_bus_volume(bus_name: String, volume: float):
	match bus_name:
		"master":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_to_db(volume))
		"sfx":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_to_db(volume))
		"music":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_to_db(volume))
		"voice":
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), volume_to_db(volume))

func volume_to_db(volume: float) -> float:
	return clamp(volume * 80.0, -80.0, 0.0)

func reset_to_defaults():
	for bus_name in persistent_volume_settings:
		set_default_volume(bus_name)