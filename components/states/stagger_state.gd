class_name StaggerState
extends State

var stagger_timer: float = 0.0

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("stagger")
	
	if actor.has_node("Stagger"):
		stagger_timer = actor.get_node("Stagger").stagger_duration

func physics_update(delta: float) -> void:
	stagger_timer -= delta
	
	if stagger_timer <= 0:
		transition_to("idle")
