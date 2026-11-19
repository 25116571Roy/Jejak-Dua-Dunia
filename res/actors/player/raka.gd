extends PlayerBase

@export var raka_data = {
	"speed": 230.0,
	"jump_force": -640.0,
	"dash_speed": 760.0,
	"dash_cooldown": 0.8,
	"attack_damage": 20.0,
	"attack_cooldown": 0.6,
	"parry_cooldown": 0.3,
	"taunt_cooldown": 0.45,
	"finisher_cooldown": 1.0,
	"taunt_radius": 260.0,
	"taunt_duration": 4.0,
	"parry_window": 0.25,
	"parry_stagger": 30.0,
	"finisher_damage": 60.0,
	"finisher_multiplier": 3.5
}

func setup_raka_specific():
	if not has_node("/root/InputManager"):
		return

	var input_manager = get_node("/root/InputManager")
	if health_component and ability_component:
		health_component.player_id = "raka"
		health_component.base_damage = raka_data.attack_damage
		ability_component.player_id = "raka"
		ability_component.setup_ability("Dash", raka_data.dash_cooldown, 0.0, raka_data.dash_cooldown)
		ability_component.setup_ability("Taunt", raka_data.taunt_cooldown * 60, raka_data.taunt_duration, raka_data.taunt_cooldown)
		ability_component.setup_ability("Finisher", raka_data.finisher_cooldown * 60, 0.0, raka_data.finisher_cooldown)

		player_data.speed = raka_data.speed
		player_data.jump_force = raka_data.jump_force
		player_data.dash_speed = raka_data.dash_speed
		player_data.dash_cooldown = raka_data.dash_cooldown
		player_data.attack_cooldown = raka_data.attack_cooldown
		player_data.parry_cooldown = raka_data.parry_cooldown
		player_data.taunt_cooldown = raka_data.taunt_cooldown
		player_data.finisher_cooldown = raka_data.finisher_cooldown
		player_data.should_emphasize_armor = true

		setup_move_keys("p1_move_left", "p1_move_right")
		setup_jump_key("p1_jump")
		setup_attack_key("p1_attack")
		setup_dash_key("p1_dash")
		setup_taunt_key("p1_taunt")
		setup_parry_key("p1_parry")
		setup_finisher_key("p1_finisher")

func _physics_process(delta):
	super._physics_process(delta)
	if health_component and health_component.is_dead:
		return

	if is_on_floor():
		update_face_direction()

	if has_node("/root/InputManager") and ability_component:
		update_cooldowns(delta)

func _handle_input():
	var input_manager = get_node("/root/InputManager") if has_node("/root/InputManager") else null

	var move_right: bool = Input.is_action_pressed("ui_right")
	var move_left: bool = Input.is_action_pressed("ui_left")

	if not input_taken and not entered_cooldown:
		if input_manager.get_input_value("p1_parry"):
			if ability_component.is_cooldown_expired("parry") and state_machine.current_state.name != "parry" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down":
				state_machine.transition_to("parry")
				input_taken = true
		elif input_manager.get_input_value("p1_taunt"):
			if ability_component.is_cooldown_expired("taunt") and state_machine.current_state.name != "taunt" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down" and health_component.current_stamina >= 25:
				ability_component.activate_ability("taunt")
				input_taken = true
		elif input_manager.get_input_value("p1_attack"):
			if ability_component.is_cooldown_expired("attack") and state_machine.current_state.name != "attack" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down" and health_component.current_stamina >= 15:
				health_component.current_stamina -= 15
				emit_signal("stamina_used", 15)
				state_machine.transition_to("attack")
				input_taken = true
		elif input_manager.get_input_value("p1_finisher"):
			if ability_component.is_cooldown_expired("finisher") and state_machine.current_state.name != "finisher" and state_machine.current_state.name != "hurt" and state_machine.current_state.name != "down" and ability_component.can_execute_finisher():
				state_machine.transition_to("finisher")
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
	player_data.attack_cooldown = raka_data.attack_cooldown

func setup_dash_key(dash: String):
	player_data.dash_key = dash
	player_data.dash_pos_one = dash
	player_data.dash_pos_two = "ui_up"

func setup_taunt_key(taunt: String):
	player_data.taunt_key = taunt

func setup_parry_key(parry: String):
	player_data.parry_key = parry
	player_data.parry_pos_one = parry
	player_data.parry_pos_two = "ui_right"

func setup_finisher_key(finisher: String):
	player_data.finisher_key = finisher
	player_data.finisher_pos_one = finisher
	player_data.finisher_pos_two = "ui_left"