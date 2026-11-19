extends HealthComponent

var is_invincible: bool = false
var hit_stop_active: bool = false
var hit_stop_duration: float = 0.0

signal stamina_used(amount: float)
signal stamina_recovered()

var current_stamina: float = 100.0
var max_stamina: float = 100.0
var stamina_recovery_rate: float = 20.0

func take_damage(distance: float = 0.0, is_weakpoint: bool = false):
	if is_invincible or is_dead:
		return

	var damage_multiplier = 1.0

	var distance_multiplier = distance_multiplier_logic(distance)
	var is_back_attack = distance_multiplier > 1.0
	if is_back_attack:
		damage_multiplier *= 1.8
	elif distance_multiplier > 0.0:
		damage_multiplier *= distance_multiplier

	if is_weakpoint:
		damage_multiplier *= 2.5

	total_damaged = min(total_damaged + damage_multiplier, 1.0)
	var actual_damage = ceil(base_damage * damage_multiplier)

	super.take_damage(actual_damage)

	if actual_damage >= ceil(base_damage):
		hit_stop_active = true
		hit_stop_duration = 0.5
		emit_signal("stun_and_pushback", is_front: false)

	if actual_damage == damage_taken * base_damage:
		hit_stop_active = true
		hit_stop_duration = 0.5
		emit_signal("stun_and_pushback", is_front: true)

	if is_dead:
		emit_signal("death")

func distance_multiplier_logic(distance: float) -> float:
	if distance > 100:
		return 1.0
	elif distance > 50:
		return 0.8
	else:
		return 0.0

func set_invincibility(enabled: bool):
	is_invincible = enabled

func _physics_process(delta):
	super._physics_process(delta)

	if has_node("/root/GameState"):
		var game_state = get_node("/root/GameState")
		if game_state.get_stage() == "stage_3_climb_lantern_hill":
			stamina_recovery_rate = 30.0
		elif game_state.get_stage() == "stage_1_desolate_forest":
			stamina_recovery_rate = 15.0
		elif game_state.get_stage() == "stage_2_shattered_relic_altar":
			stamina_recovery_rate = 25.0
		else:
			stamina_recovery_rate = 20.0

	if not is_dead and current_stamina < max_stamina:
		current_stamina = min(current_stamina + stamina_recovery_rate * delta, max_stamina)
		emit_signal("stamina_recovered")

	_check_cooldown_expiration()

func consume_stamina(amount: float) -> bool:
	if current_stamina >= amount:
		current_stamina -= amount
		emit_signal("stamina_used", amount)
		return true
	return false

func _check_cooldown_expiration():
	hit_stop_duration -= get_physics_process_delta_time()
	if hit_stop_duration <= 0:
		hit_stop_active = false
		stop_hit_stop()

func stop_hit_stop():
	# Implement actual hit stop logic here
	pass

func get_stamina() -> float:
	return current_stamina

func is_in_hit_stop() -> bool:
	return hit_stop_active