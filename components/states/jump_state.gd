class_name JumpState
extends State

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("jump")

func physics_update(_delta: float) -> void:
	if actor is CharacterBody2D:
		if actor.velocity.y > 0:
			transition_to("fall")
		
		if actor.is_on_floor():
			transition_to("idle")
