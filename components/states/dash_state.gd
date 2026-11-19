class_name DashState
extends State

@export var dash_duration: float = 0.16

var timer: float = 0.0

func enter() -> void:
	timer = dash_duration
	if actor.has_method("play_animation"):
		actor.play_animation("dash")
	
	if actor.has_method("set_invincible"):
		actor.invincible = true

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		if actor.has_method("set_invincible"):
			actor.invincible = false
		transition_to("idle")
