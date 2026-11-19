extends Control

@onready var level_label := $VBoxContainer/LevelLabel
@onready var time_label := $VBoxContainer/TimeLabel
@onready var deaths_label := $VBoxContainer/DeathsLabel
@onready var combo_label := $VBoxContainer/ComboLabel

signal continue_pressed

func _ready() -> void:
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue_pressed)

func show_results(level_id: String, time: float, deaths: int, max_combo: int) -> void:
	level_label.text = "Babak %s Selesai!" % level_id
	time_label.text = "Waktu: %s" % _format_time(time)
	deaths_label.text = "Jatuh: %d kali" % deaths
	combo_label.text = "Kombo Maksimal: %d" % max_combo
	
	show()

func _format_time(seconds: float) -> String:
	var minutes := int(seconds) / 60
	var secs := int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func _on_continue_pressed() -> void:
	continue_pressed.emit()
	hide()
