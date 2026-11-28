class_name WaveManager
extends Node

@export var wave_data: WaveData
@export var spawners: Array[NodePath] = []
@export var auto_start: bool = true

var current_wave: int = -1
var enemies_alive: int = 0
var all_waves_cleared: bool = false
var _active_enemies: Array[Node] = []

func _ready() -> void:
	if not wave_data:
		var default_res := load("res://data/wave_data/babak1_waves.tres")
		if default_res is WaveData:
			wave_data = default_res

	# Auto-discover spawners jika belum diset di inspector
	if spawners.is_empty():
		var spawner_parent := get_parent().get_node_or_null("Spawners")
		if not spawner_parent:
			spawner_parent = get_parent().get_node_or_null("EnemySpawners")
		if spawner_parent:
			for child in spawner_parent.get_children():
				if child is Marker2D or child is Node2D:
					spawners.append(child.get_path())

	if auto_start:
		# Beri waktu 1.5 detik agar scene selesai dimuat
		get_tree().create_timer(1.5).timeout.connect(start)

func start() -> void:
	if wave_data and not wave_data.gelombang.is_empty():
		_start_wave(0)

func _start_wave(idx: int) -> void:
	current_wave = idx
	enemies_alive = 0
	_active_enemies.clear()
	
	GameState.simpan_checkpoint(1, idx)
	EventBus.wave_started.emit(1, idx + 1)
	EventBus.show_prompt.emit("Gelombang %d Dimulai!" % (idx + 1), 1)
	EventBus.show_prompt.emit("Gelombang %d Dimulai!" % (idx + 1), 2)
	
	await get_tree().create_timer(1.2).timeout
	if idx < wave_data.gelombang.size():
		_spawn_wave(wave_data.gelombang[idx])

func _spawn_wave(config: Dictionary) -> void:
	var enemy_list: Array = config.get("enemies", [])
	for spawn_info in enemy_list:
		var scene_path: String = spawn_info.get("scene", "")
		if scene_path.is_empty():
			continue
			
		var enemy_scene := load(scene_path)
		if not enemy_scene:
			continue
			
		var enemy: Node = enemy_scene.instantiate()
		var spawner_idx: int = spawn_info.get("spawner_index", 0)
		
		var spawn_pos: Vector2 = Vector2.ZERO
		if not spawners.is_empty():
			var safe_idx: int = clamp(spawner_idx, 0, spawners.size() - 1)
			var spawner_node := get_node_or_null(spawners[safe_idx])
			if spawner_node is Node2D:
				spawn_pos = spawner_node.global_position
				
		get_parent().add_child(enemy)
		if enemy is Node2D:
			enemy.global_position = spawn_pos
			
		enemies_alive += 1
		_active_enemies.append(enemy)
		enemy.tree_exited.connect(_on_enemy_exited.bind(enemy))

func _on_enemy_exited(enemy: Node) -> void:
	if enemy in _active_enemies:
		_active_enemies.erase(enemy)
		enemies_alive = max(0, enemies_alive - 1)
		if enemies_alive == 0 and not all_waves_cleared:
			_on_wave_cleared()

func _on_wave_cleared() -> void:
	EventBus.wave_cleared.emit(1, current_wave + 1)
	EventBus.show_prompt.emit("Gelombang %d Bersih!" % (current_wave + 1), 1)
	EventBus.show_prompt.emit("Gelombang %d Bersih!" % (current_wave + 1), 2)
	
	if current_wave + 1 >= wave_data.gelombang.size():
		all_waves_cleared = true
		# Cek aktivasi portal
		var portal := get_parent().get_node_or_null("Portal")
		if portal and portal.has_method("check_activation"):
			portal.check_activation()
		for p in get_tree().get_nodes_in_group("portals"):
			if p.has_method("check_activation"):
				p.check_activation()
	else:
		await get_tree().create_timer(2.5).timeout
		_start_wave(current_wave + 1)
