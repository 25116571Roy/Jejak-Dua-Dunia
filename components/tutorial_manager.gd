extends Node

class_name TutorialManager

signal tutorial_step_completed(step_id: String)
signal tutorial_completed()

@export var tutorial_steps: Array[Dictionary] = []

var current_step_index: int = 0
var is_active: bool = false
var step_conditions_met: Dictionary = {}

func _ready() -> void:
	_setup_tutorial_steps()

func _setup_tutorial_steps() -> void:
	tutorial_steps = [
		{
			"id": "movement",
			"text": "Gunakan A/D untuk bergerak (Raka) atau ←/→ (Nisa)",
			"condition": "player_moved",
			"duration": 5.0
		},
		{
			"id": "jump",
			"text": "Tekan W untuk melompat (Raka) atau ↑ (Nisa)",
			"condition": "player_jumped",
			"duration": 5.0
		},
		{
			"id": "attack",
			"text": "Tekan F untuk menyerang (Raka) atau / (Nisa)",
			"condition": "player_attacked",
			"duration": 5.0
		},
		{
			"id": "parry",
			"text": "Raka: Tekan H untuk Parry saat musuh menyerang",
			"condition": "parry_performed",
			"duration": 10.0
		},
		{
			"id": "dash",
			"text": "Nisa: Tekan . untuk Dash menghindari serangan",
			"condition": "dash_performed",
			"duration": 10.0
		}
	]

func start_tutorial() -> void:
	is_active = true
	current_step_index = 0
	_show_current_step()

func _show_current_step() -> void:
	if current_step_index >= tutorial_steps.size():
		_complete_tutorial()
		return
	
	var step := tutorial_steps[current_step_index]
	_display_tutorial_text(step.text)

func _display_tutorial_text(text: String) -> void:
	print("Tutorial: ", text)

func check_condition(condition: String) -> void:
	if not is_active:
		return
	
	var current_step := tutorial_steps[current_step_index]
	
	if current_step.condition == condition:
		_complete_current_step()

func _complete_current_step() -> void:
	var step := tutorial_steps[current_step_index]
	tutorial_step_completed.emit(step.id)
	
	current_step_index += 1
	_show_current_step()

func _complete_tutorial() -> void:
	is_active = false
	tutorial_completed.emit()
