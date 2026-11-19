class_name WaveManager
extends Node

signal wave_completed(wave_index: int)
signal all_waves_complete()

@export var wave_data: Array[WaveData]

var current_wave_index: int = 0
var is_wave_active: bool = false
var enemies_spawned: int = 0
var enemies_alive: int = 0
var spawn_timer: float = 0.0

func start_next_wave() -> void:
	if current_wave_index >= wave_data.size():
		emit_signal("all_waves_complete")
		return
	
	current_wave_index += 1
	is_wave_active = true
	enemies_spawned = 0
	enemies_alive = 0
	spawn_timer = 0.0
	
	emit_signal("wave_completed", current_wave_index)

func _process(delta: float) -> void:
	if not is_wave_active:
		return
	
	var wave := wave_data[current_wave_index - 1]
	
	if enemies_spawned < wave.get_enemies_count():
		spawn_timer -= delta
		if spawn_timer <= 0:
			_spawn_enemy(wave)
			spawn_timer = wave.get_spawn_interval()
	
	if enemies_alive <= 0:
		is_wave_active = false
		if current_wave_index < wave_data.size():
			yield(get_tree().create_timer(3.0), "timeout")
			start_next_wave()

func _spawn_enemy(wave: WaveData) -> void:
	if wave.enemies.is_empty():
		return
	
	var random_index := randi() % wave.enemies.size()
	var enemy_scene := wave.enemies[random_index]
	var enemy_node := enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy_node)
	
	enemies_spawned += 1
	enemies_alive += 1
	
	enemy_node.death.connect(_on_enemy_dead)

func _on_enemy_dead() -> void:
	enemies_alive -= 1