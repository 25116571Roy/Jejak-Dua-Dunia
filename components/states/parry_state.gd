class_name ParryState
extends State

@export var parry_window: float = 0.25

var timer: float = 0.0
var parry_successful: bool = false

func enter() -> void:
	timer = parry_window
	parry_successful = false
	
	if actor.has_method("play_animation"):
		actor.play_animation("parry")

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		if parry_successful:
			transition_to("attack")
		else:
			transition_to("idle")

func on_parry_success() -> void:
	parry_successful = true
	EventBus.emit_parry_success(actor)
