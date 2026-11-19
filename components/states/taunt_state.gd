class_name TauntState
extends State

@export var taunt_duration: float = 0.5

var timer: float = 0.0

func enter() -> void:
	timer = taunt_duration
	if actor.has_method("play_animation"):
		actor.play_animation("taunt")
	
	EventBus.emit_taunt_activated(actor)
	_apply_taunt_effect()

func _apply_taunt_effect() -> void:
	var taunt_radius: float = 260.0
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance: float = actor.global_position.distance_to(enemy.global_position)
		if distance <= taunt_radius:
			if enemy.has_method("set_target"):
				enemy.set_target(actor)

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		transition_to("idle")
