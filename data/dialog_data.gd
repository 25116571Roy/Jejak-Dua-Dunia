class_name DialogData
extends Resource

@export var character_name: String
@export var character_emotion: String
@export var text: String
@export var portrait_path: String

func _init(p_name: String = "", p_emotion: String = "", p_text: String = "", p_portrait: String = "") -> void:
	character_name = p_name
	character_emotion = p_emotion
	text = p_text
	portrait_path = p_portrait
