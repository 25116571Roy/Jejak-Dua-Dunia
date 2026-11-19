class_name WaveData
extends Resource

@export var wave_number: int = 1
@export var enemies: Array[PackedScene] = []
@export var enemy_count: int = 3
@export var spawn_interval: float = 1.5
@export var difficulty_multiplier: float = 1.0

func get_enemies_count() -> int:
	return enemy_count * difficulty_multiplier

func get_spawn_interval() -> float:
	return spawn_interval / difficulty_multiplier
