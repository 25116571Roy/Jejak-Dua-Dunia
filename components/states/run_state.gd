class_name RunState
extends State

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("run")

func physics_update(_delta: float) -> void:
	if actor is CharacterBody2D:
		if abs(actor.velocity.x) < 10:
			transition_to("idle")
		
		if not actor.is_on_floor():
			transition_to("fall")
