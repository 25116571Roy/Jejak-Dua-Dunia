class_name HurtState
extends State

@export var hurt_duration: float = 0.3

var timer: float = 0.0

func enter() -> void:
	timer = hurt_duration
	if actor.has_method("play_animation"):
		actor.play_animation("hurt")

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		transition_to("idle")
