extends PlayerBase

@export var nisa_data = {
	"speed": 340.0,
	"jump_force": -700.0,
	"double_jump_force": -330.0,
	"dash_speed": 760.0,
	"dash_cooldown": 0.8,
	"weakpoint_cooldown": 0.3,
	"weakpoint_attack_cooldown": 0.3,
	"attack_damage": 9.0,
	"air_attacks": true,
	"weakpoint_multiplier": 2.5,
	"back_attack_multiplier": 1.8,
	"dash_attack_multiplier": 1.4,
	"air_attack_multiplier": 1.2
}

func setup_nisa_specific():
	if not has_node("/root/InputManager"):
		return

	var input_manager = get_node("/root/InputManager")
	if health_component and ability_component:
		health_component.player_id = "nisa"
		health_component.base_damage = nisa_data.attack_damage
		ability_component.player_id = "nisa"
		ability_component.setup_ability("Dash", nisa_data.dash_cooldown, 0.0, nisa_data.dash_cooldown)
		ability_component.setup_ability("Weakpoint", nisa_data.weakpoint_cooldown, 0.0, nisa_data.weakpoint_cooldown)

		player_data.speed = nisa_data.speed
		player_data.jump_force = nisa_data.jump_force
		player_data.double_jump_force = nisa_data.double_jump_force
		player_data.dash_speed = nisa_data.dash_speed
		player_data.dash_cooldown = nisa_data.dash_cooldown
		player_data.attack_damage = nisa_data.attack_damage
		player_data.should_emphasize_agility = true

		setup_move_keys("p2_move_left", "p2_move_right")
		setup_jump_key("p2_jump")
		setup_attack_key("p2_attack")
		setup_dash_key("p2_dash")
		setup_weakpoint_key("p2_weakpoint", "p2_weakpoint_fast")

func _physics_process(delta):
	super._physics_process(delta)
	if health_component and health_component.is_dead:
		return

	if has_node("/root/InputManager") and ability_component:
		update_cooldowns(delta)

func _handle_input():
	var input_manager = get_node("/root/InputManager") if has_node("/root/InputManager") else null

	var move_right: bool = Input.is_action_pressed("ui_right")
	var move_left: bool = Input.is_action_pressed("ui_left")

	if not input_taken and not entered_cooldown:
		if input_manager.get_input_value("p2_dash"):
			if ability_component.is_cooldown_expired("dash") and state_machine.current_state.name != "dash" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down" and ability_component.can_execute_dash():
				prepare_execute_dash(nisa_data.dash_speed, 0.8, nisa_data.dash_cooldown)
				state_machine.transition_to("dash")
				input_taken = true
		elif input_manager.get_input_value("p2_attack"):
			if ability_component.is_cooldown_expired("attack") and state_machine.current_state.name != "attack" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down" and health_component.current_stamina >= 10:
				health_component.current_stamina -= 10
				emit_signal("stamina_used", 10)
				state_machine.transition_to("attack")
				input_taken = true

	if move_right:
		velocity.x = player_data.speed
	elif move_left:
		velocity.x = -player_data.speed
	else:
		velocity.x = 0

func update_cooldowns(delta):
	if ability_component:
		ability_component.update_cooldowns(delta, ability_component)

func prepare_execute_dash(speed: float, duration: float, cooldown: float):
	player_data.dash_speed = speed
	player_data.dash_duration = duration
	player_data.dash_cooldown = cooldown

func is_broken_state():
	return state_machine.current_state.name == "hurt" or state_machine.current_state.name == "down"

func update_face_direction():
	if velocity.x > 0:
		facing_direction = 1.0
	elif velocity.x < 0:
		facing_direction = -1.0

func setup_move_keys(left: String, right: String):
	player_data.move_left_key = left
	player_data.move_right_key = right

func setup_jump_key(up: String):
	player_data.jump_key = up

func setup_attack_key(attack: String):
	player_data.attack_key = attack
	player_data.attack_cooldown = nisa_data.weakpoint_attack_cooldown

func setup_dash_key(dash: String):
	player_data.dash_key = dash
	player_data.dash_pos_one = dash
	player_data.dash_pos_two = "ui_up"

func setup_weakpoint_key(weakpoint: String, fast_weakpoint: String):
	player_data.weakpoint_key = weakpoint
	player_data.weakpoint_pos_one = weakpoint
	player_data.weakpoint_pos_two = fast_weakpoint