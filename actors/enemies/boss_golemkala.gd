class_name BossGolemkala
extends EnemyBase

signal phase_changed(phase: int)

@export var phase_1_health_threshold: float = 0.66
@export var phase_2_health_threshold: float = 0.33
@export var slam_attack_delay: float = 1.0
@export var charge_distance: float = 400.0
@export var projectile_speed: float = 300.0

var current_phase: int = 1
var phase_transition_cooldown: float = 0.0
var attack_pattern_index: int = 0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_dead:
		return
	
	_check_phase_transition()
	_update_attack_pattern(delta)

func _check_phase_transition() -> void:
	var health_percentage := health.get_health_percentage()
	var new_phase := 1
	
	if health_percentage <= phase_2_health_threshold:
		new_phase = 3
	elif health_percentage <= phase_1_health_threshold:
		new_phase = 2
	
	if new_phase != current_phase:
		_transition_to_phase(new_phase)

func _transition_to_phase(new_phase: int) -> void:
	current_phase = new_phase
	phase_changed.emit(current_phase)
	EventBus.boss_phase_changed.emit(current_phase)
	
	if state_machine:
		state_machine.change_state("idle")

func _update_attack_pattern(delta: float) -> void:
	phase_transition_cooldown -= delta
	
	if phase_transition_cooldown > 0:
		return
	
	select_target()
	
	if not target_player:
		return
	
	match current_phase:
		1:
			_phase_1_behavior()
		2:
			_phase_2_behavior()
		3:
			_phase_3_behavior()

func _phase_1_behavior() -> void:
	var attacks := ["slam", "charge"]
	var attack := attacks[attack_pattern_index % attacks.size()]
	
	if attack == "slam":
		_perform_slam()
	elif attack == "charge":
		_perform_charge()
	
	attack_pattern_index += 1
	phase_transition_cooldown = enemy_data.attack_cooldown

func _phase_2_behavior() -> void:
	var attacks := ["slam", "charge", "projectile"]
	var attack := attacks[attack_pattern_index % attacks.size()]
	
	if attack == "slam":
		_perform_slam()
	elif attack == "charge":
		_perform_charge()
	elif attack == "projectile":
		_perform_projectile_volley()
	
	attack_pattern_index += 1
	phase_transition_cooldown = enemy_data.attack_cooldown

func _phase_3_behavior() -> void:
	var attacks := ["slam", "charge", "projectile"]
	var attack := attacks[attack_pattern_index % attacks.size()]
	
	if attack == "slam":
		_perform_slam()
	elif attack == "charge":
		_perform_charge()
	elif attack == "projectile":
		_perform_projectile_volley()
	
	attack_pattern_index += 1
	phase_transition_cooldown = enemy_data.attack_cooldown * 0.7

func _perform_slam() -> void:
	if state_machine:
		state_machine.change_state("slam")

func _perform_charge() -> void:
	if state_machine:
		state_machine.change_state("charge")

func _perform_projectile_volley() -> void:
	if state_machine:
		state_machine.change_state("projectile")
