extends CharacterBody2D

class_name PlayerBase

signal player_damaged(damage: float)
signal player_death()
signal player_revived(health: float)
signal player_disappeared()
signal player_reappeared()

@export var is_p2: bool = false
@export var is_raka: bool = false
@export var is_nisa: bool = false
@export var player_PlayerData

var input_config: Dictionary = {}
var state_machine: PlayerStateMachine
var health_component: HealthComponent
var ability_component: AbilityComponent

var status_markers: Array = []
var weak_points: Array = []
var current_weak_point_index: int = 0
var weak_point_detected: bool = false

wait_for_input := false
entered_cooldown := false
input_taken := false

func _ready():
	init_player()
	setup_player_specific()

func init_player():
	if is_raka:
		setup_raka()
	elif is_nisa:
		setup_nisa()

func setup_raka():
	is_p2 = false if is_p2 == false else is_p2
	player_data = setup_raka_data()

func setup_nisa():
	is_p2 = true if is_p2 == false else is_p2
	player_data = setup_nisa_data()

func setup_raka_data() -> PlayerData:
	var data = PlayerData.new()
	data.player_id = "raka"
	data.color = Color(0xFA8C42, 1.0)
	data.radius = 60.0
	data.max_stamina = 100.0
	data.current_stamina = 100.0
	data.should_emphasize_armor = true
	return data

func setup_nisa_data() -> PlayerData:
	var data = PlayerData.new()
	data.player_id = "nisa"
	data.color = Color(0x00FFFF, 1.0)
	data.radius = 45.0
	data.max_stamina = 80.0
	data.current_stamina = 80.0
	data.should_emphasize_agility = true
	return data

func _physics_process(delta):
	_handle_input()
	if health_component and health_component.is_dead:
		return

	move_and_slide()

func setup_player_specific():
	# Create and assign components
	health_component = HealthComponent.new()
	add_child(health_component)

	ability_component = AbilityComponent.new()
	add_child(ability_component)

	state_machine = PlayerStateMachine.new()
	state_machine.setup_player_specific()
	state_machine.player_id = health_component.player_id
	add_child(state_machine)

## ===== INPUT HANDLING =====

func _handle_input():
	var input_manager = get_node("/root/InputManager") if has_node("/root/InputManager") else null

	var move_right: bool = input_manager.get_input_value("p1_move_right") if not is_p2 else input_manager.get_input_value("p2_move_right")
	var move_left: bool = input_manager.get_input_value("p1_move_left") if not is_p2 else input_manager.get_input_value("p2_move_left")

	if not input_taken and not entered_cooldown:
		if input_manager.get_input_value("p1_jump") if not is_p2 else input_manager.get_input_value("p2_jump"):
			if state_machine.current_state.name == "ready_to_jump":
				state_machine.input_most_recent = state_machine.current_state.name
				state_machine.transition_to("jump")
				input_taken = true
		elif input_manager.get_input_value("p2_dash") if is_p2 and input_manager.get_input_value("p2_dashboard") if is_p2 and input_manager.get_input_value("p2_attack"):
			# Fixed logic for P2 dash

	if move_right:
		velocity.x = player_data.speed
	elif move_left:
		velocity.x = -player_data.speed
	else:
		velocity.x = 0

func _get_stick_input() -> float:
	var x_axis = Input.get_axis("p1_move_left", "p1_move_right") if not is_p2 else Input.get_axis("p2_move_left", "p2_move_right")
	return x_axis

func _get_joystick_or_dpad_input():
	var input = Input.get_axis("ui_left", "ui_right") if is_p2 else Input.get_axis("ui_left", "ui_right")
	if abs(input) < 0.1:
		input = Input.get_axis("p1_move_left", "p1_move_right") if not is_p2 else Input.get_axis("p2_move_left", "p2_move_right")
	return input

func _get_action_base(key_one: String, key_two: String, gamepad_base: String = "button_cross") -> bool:
	var primary = Input.is_action_just_pressed(key_one)
	var secondary = false
	if key_two != "":
		secondary = Input.is_action_just_pressed(key_two)

	# Gamepad input
	var gamepad_check := false
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed(key_two):
		gamepad_check = true
	elif Input.is_action_just_pressed("ui_right"):
		gamepad_check = true
	elif Input.is_action_just_pressed("ui_down"):
		gamepad_check = true
	elif Input.is_action_just_pressed("ui_left"):
		gamepad_check = inactive