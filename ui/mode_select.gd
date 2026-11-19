extends Control

signal mode_selected(mode: String)

func _ready() -> void:
	$VBoxContainer/TwoPlayerButton.pressed.connect(_on_two_player_pressed)
	$VBoxContainer/SoloButton.pressed.connect(_on_solo_pressed)
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_two_player_pressed() -> void:
	mode_selected.emit("two_player")
	SceneManager.goto_level("1")

func _on_solo_pressed() -> void:
	mode_selected.emit("solo")
	SceneManager.goto_level("1")

func _on_back_pressed() -> void:
	SceneManager.goto_main_menu()
