extends CharacterBody2D

signal input_changed(action: String, state: bool)

var input_config = {
	"p1_move_right": {"key": KEY_D, "gamepad": "stick_left_right", "treated_as": "dpad"},
	"p1_move_left": {"key": KEY_A, "gamepad": "stick_left_right", "treated_as": "dpad"},
	"p1_jump": {"key": KEY_W, "gamepad": "button_cross", "treated_as": "action"},
	"p1_attack": {"key": KEY_F, "gamepad": "button_square", "treated_as": "action"},
	"p1_parry": {"key": KEY_H, "gamepad": "button_b", "treated_as": "action"},
	"p1_taunt": {"key": KEY_G, "gamepad": "button_y", "treated_as": "action"},
	"p1_finisher": {"key": KEY_T, "gamepad": "button_r1", "treated_as": "action"},

	"p2_move_right": {"key": KEY_RIGHT, "gamepad": "stick_left_right", "treated_as": "dpad"},
	"p2_move_left": {"key": KEY_LEFT, "gamepad": "stick_left_right", "treated_as": "dpad"},
	"p2_jump": {"key": KEY_UP, "gamepad": "button_cross", "treated_as": "action"},
	"p2_attack": {"key": KEY_X, "gamepad": "button_circle", "treated_as": "action"},
	"p2_dash": {"key": KEY_SHIFT, "gamepad": "button_b", "treated_as": "action"},
	"p2_weakpoint": {"key": KEY_C, "gamepad": "button_y", "treated_as": "action"},
	"p2_weakpoint_fast": {"key": KEY_Z, "gamepad": "unknown", "treated_as": "action"}
}

func _ready():
	print("InputRouter initialized")

func get_input_value(action: String) -> bool:
	if has_node("/root/InputManager"):
		return get_node("/root/InputManager").get_input_value(action)
	return false

func bind_inputs_to_game_node(node: Node):
	for action_name in input_config:
		var config = input_config[action_name]
		node.set(action_name, config)
	return input_config