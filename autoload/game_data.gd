extends Node

var level_data: Dictionary = {
	"babak1": {
		"name": "Hutan Kehancuran",
		"duration": 300,
		"waves": 3,
		"theme": "preservation",
		"theme_color": Color.GREEN
	},
	"babak2": {
		"name": "Reruntuhan Penempa Jiwa",
		"duration": 480,
		"boss": "Golemkala",
		"theme": "gotong_royong",
		"theme_color": Color.ORANGE
	},
	"babak3": {
		"name": "Bukit Lentera",
		"duration": 240,
		"theme": "pulang",
		"theme_color": Color.CYAN
	}
}

var character_data: Dictionary = {
	"raka": {
		"name": "Raka",
		"age": 16,
		"color": Color.ORANGE,
		"role": "Heavy, Defensive, Rhythm Setter"
	},
	"nisa": {
		"name": "Nisa",
		"age": 12,
		"color": Color.CYAN,
		"role": "Agile, Offensive, Precision"
	}
}

func get_level_name(level_id: String) -> String:
	return level_data.get(level_id, {}).get("name", "Unknown Level")

func get_character_name(char_id: String) -> String:
	return character_data.get(char_id, {}).get("name", "Unknown")

func get_character_color(char_id: String) -> Color:
	return character_data.get(char_id, {}).get("color", Color.WHITE)
