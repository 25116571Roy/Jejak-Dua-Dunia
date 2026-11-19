class_name DeadState
extends State

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("dead")
	
	if actor.has_method("on_death"):
		actor.on_death()
	
	await get_tree().create_timer(2.0).timeout
	
	if actor:
		actor.queue_free()

func physics_update(_delta: float) -> void:
	pass
