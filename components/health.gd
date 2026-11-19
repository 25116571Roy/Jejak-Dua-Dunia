extends Node

signal health_changed(current: float, max_hp: float)
signal health_depleted()
signal invincibility_started()
signal invincibility_ended()

@export var max_health: float = 100.0
@export var invincibility_duration: float = 1.0

var current_health: float = max_health
var is_invincible: bool = false
var is_dead: bool = false

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	if is_invincible or is_dead:
		return
	
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		is_dead = true
		health_depleted.emit()
	else:
		start_invincibility()

func heal(amount: float) -> void:
	if is_dead:
		return
	
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func start_invincibility() -> void:
	if is_invincible:
		return
	
	is_invincible = true
	invincibility_started.emit()
	
	await get_tree().create_timer(invincibility_duration).timeout
	
	is_invincible = false
	invincibility_ended.emit()

func reset() -> void:
	current_health = max_health
	is_dead = false
	is_invincible = false
	health_changed.emit(current_health, max_health)

func get_health_percentage() -> float:
	return current_health / max_health
