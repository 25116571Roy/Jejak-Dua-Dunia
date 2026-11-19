extends Node

var hitstop_duration: float = 0.0
var time_scale_backup: float = 1.0

func _process(delta: float) -> void:
	if hitstop_duration > 0:
		hitstop_duration -= delta
		if hitstop_duration <= 0:
			_restore_time_scale()

func apply_hitstop(duration: float, time_scale: float = 0.0) -> void:
	if hitstop_duration <= 0:
		time_scale_backup = Engine.time_scale
	
	hitstop_duration = max(hitstop_duration, duration)
	Engine.time_scale = time_scale

func _restore_time_scale() -> void:
	Engine.time_scale = time_scale_backup
	hitstop_duration = 0.0

func light_hit() -> void:
	apply_hitstop(0.05, 0.5)

func medium_hit() -> void:
	apply_hitstop(0.1, 0.3)

func heavy_hit() -> void:
	apply_hitstop(0.15, 0.1)
