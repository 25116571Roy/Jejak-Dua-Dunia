extends Node

enum InputDevice {
	KEYBOARD_P1,
	KEYBOARD_P2,
	GAMEPAD_0,
	GAMEPAD_1,
	GAMEPAD_2,
	GAMEPAD_3
}

var player1_device: InputDevice = InputDevice.KEYBOARD_P1
var player2_device: InputDevice = InputDevice.KEYBOARD_P2

func _ready() -> void:
	setup_input_map()
	detect_gamepads()

func setup_input_map() -> void:
	_add_keyboard_p1_actions()
	_add_keyboard_p2_actions()

func _add_keyboard_p1_actions() -> void:
	_create_action("p1_move_left", [KEY_A])
	_create_action("p1_move_right", [KEY_D])
	_create_action("p1_jump", [KEY_W])
	_create_action("p1_attack", [KEY_F])
	_create_action("p1_parry", [KEY_H])
	_create_action("p1_taunt", [KEY_G])
	_create_action("p1_finisher", [KEY_T])

func _add_keyboard_p2_actions() -> void:
	_create_action("p2_move_left", [KEY_LEFT])
	_create_action("p2_move_right", [KEY_RIGHT])
	_create_action("p2_jump", [KEY_UP])
	_create_action("p2_attack", [KEY_SLASH])
	_create_action("p2_dash", [KEY_PERIOD])
	_create_action("p2_seed", [KEY_DOWN])

func _create_action(action_name: String, keys: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	
	for key in keys:
		var event := InputEventKey.new()
		event.keycode = key
		if not InputMap.action_has_event(action_name, event):
			InputMap.action_add_event(action_name, event)

func detect_gamepads() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		print("Gamepad connected: ", device)
	else:
		print("Gamepad disconnected: ", device)

func get_axis(player_id: int, negative: String, positive: String) -> float:
	var prefix := "p1_" if player_id == 1 else "p2_"
	return Input.get_axis(prefix + negative, prefix + positive)

func is_action_pressed(player_id: int, action: String) -> bool:
	var prefix := "p1_" if player_id == 1 else "p2_"
	return Input.is_action_pressed(prefix + action)

func is_action_just_pressed(player_id: int, action: String) -> bool:
	var prefix := "p1_" if player_id == 1 else "p2_"
	return Input.is_action_just_pressed(prefix + action)
