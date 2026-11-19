class_name PlayerBase
extends CharacterBody2D

signal ability_used(ability_name: String)
signal combo_increased(count: int)

@export var player_id: int = 1
@export var player_data: PlayerData

var state_machine: StateMachine
var health: Health
var stats: Dictionary = {}
var is_down: bool = false
var combo_count: int = 0
var invincible: bool = false
var facing_direction: float = 1.0

func _ready() -> void:
	if not player_data:
		var new_data := PlayerData.new()
		new_data.character_name = "Default"
		player_data = new_data
	
	_setup_components()
	_setup_stats()

func _setup_components() -> void:
	state_machine = $StateMachine
	health = $Health
	
	if not health:
		health = Health.new()
		add_child(health)
	
	if not state_machine:
		state_machine = StateMachine.new()
		add_child(state_machine)

func _setup_stats() -> void:
	stats = {
		"max_health": player_data.max_health,
		"movement_speed": player_data.movement_speed,
		"jump_impulse": player_data.jump_impulse,
		"attack_damage": player_data.attack_damage,
		"attack_cooldown": player_data.attack_cooldown
	}

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += player_data.gravity * delta
	
	move_and_slide()

func take_damage(damage: float, direction: Vector2, knockback: float, stagger: float = 0.0) -> void:
	if is_down or invincible:
		return
	
	health.take_damage(damage)
	
	if knockback > 0:
		velocity += direction * knockback

func start_combo() -> void:
	combo_count = 1
	combo_increased.emit(combo_count)

func increase_combo() -> void:
	combo_count += 1
	combo_increased.emit(combo_count)

func reset_combo() -> void:
	combo_count = 0

func go_down() -> void:
	if is_down:
		return
	
	is_down = true
	GameState.set_player_down(player_id, true)

func can_be_saved() -> bool:
	return is_down

func be_saved() -> void:
	is_down = false
	GameState.set_player_down(player_id, false)
