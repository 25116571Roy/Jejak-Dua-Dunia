extends Control

signal resume_pressed
signal options_pressed
signal main_menu_pressed

var is_paused: bool = false

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed() -> void:
	toggle_pause()
	resume_pressed.emit()

func _on_options_pressed() -> void:
	options_pressed.emit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto_main_menu()
	main_menu_pressed.emit()
