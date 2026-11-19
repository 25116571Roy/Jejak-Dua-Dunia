extends Control

@onready var music_slider := $VBoxContainer/MusicVolume/Slider
@onready var sfx_slider := $VBoxContainer/SFXVolume/Slider
@onready var voice_slider := $VBoxContainer/VoiceVolume/Slider
@onready var fullscreen_check := $VBoxContainer/Fullscreen/CheckBox
@onready var vsync_check := $VBoxContainer/VSync/CheckBox

signal settings_changed(settings: Dictionary)
signal back_pressed

var current_settings: Dictionary = {}

func _ready() -> void:
	_load_settings()
	_connect_signals()

func _load_settings() -> void:
	current_settings = SaveManager.load_settings()
	
	music_slider.value = current_settings.get("music_volume", 0.8)
	sfx_slider.value = current_settings.get("sfx_volume", 0.8)
	voice_slider.value = current_settings.get("voice_volume", 0.8)
	fullscreen_check.button_pressed = current_settings.get("fullscreen", false)
	vsync_check.button_pressed = current_settings.get("vsync", true)
	
	_apply_settings()

func _connect_signals() -> void:
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	voice_slider.value_changed.connect(_on_voice_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vsync_check.toggled.connect(_on_vsync_toggled)
	
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_music_changed(value: float) -> void:
	current_settings.music_volume = value
	AudioManager.set_music_volume(linear_to_db(value))
	_save_settings()

func _on_sfx_changed(value: float) -> void:
	current_settings.sfx_volume = value
	AudioManager.set_sfx_volume(linear_to_db(value))
	_save_settings()

func _on_voice_changed(value: float) -> void:
	current_settings.voice_volume = value
	AudioManager.set_voice_volume(linear_to_db(value))
	_save_settings()

func _on_fullscreen_toggled(pressed: bool) -> void:
	current_settings.fullscreen = pressed
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_save_settings()

func _on_vsync_toggled(pressed: bool) -> void:
	current_settings.vsync = pressed
	if pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	_save_settings()

func _apply_settings() -> void:
	AudioManager.set_music_volume(linear_to_db(current_settings.music_volume))
	AudioManager.set_sfx_volume(linear_to_db(current_settings.sfx_volume))
	AudioManager.set_voice_volume(linear_to_db(current_settings.voice_volume))
	
	if current_settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if current_settings.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _save_settings() -> void:
	SaveManager.save_settings(current_settings)
	settings_changed.emit(current_settings)

func _on_back_pressed() -> void:
	back_pressed.emit()
