class_name AttackState
extends State

@export var attack_duration: float = 0.4

var timer: float = 0.0

func enter() -> void:
	timer = attack_duration
	if actor.has_method("play_animation"):
		actor.play_animation("attack")

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		transition_to("idle")
