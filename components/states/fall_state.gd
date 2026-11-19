class_name FallState
extends State

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("fall")

func physics_update(_delta: float) -> void:
	if actor is CharacterBody2D:
		if actor.is_on_floor():
			transition_to("idle")
