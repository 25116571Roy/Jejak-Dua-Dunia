extends Node

signal scene_loaded(scene_name: String)
signal scene_transition_started()
signal scene_transition_finished()

var current_scene: Node = null
var is_transitioning: bool = false

func _ready() -> void:
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(scene_path: String, transition_duration: float = 0.5) -> void:
	if is_transitioning:
		return
	
	is_transitioning = true
	scene_transition_started.emit()
	
	await get_tree().create_timer(transition_duration).timeout
	
	call_deferred("_deferred_change_scene", scene_path)

func _deferred_change_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.free()
	
	var new_scene := load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene
	
	is_transitioning = false
	scene_transition_finished.emit()
	scene_loaded.emit(scene_path)

func reload_current_scene() -> void:
	if current_scene:
		change_scene(current_scene.scene_file_path)

func goto_main_menu() -> void:
	change_scene("res://ui/main_menu.tscn")

func goto_level(level_id: String) -> void:
	var level_path := "res://levels/babak%s.tscn" % level_id
	change_scene(level_path)
