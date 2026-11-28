class_name SeedPoint
extends Area2D

@export var grow_time: float = 6.0
var is_planted: bool = false
var is_grown: bool = false

@onready var seed_visual: Node2D = $SeedVisual
@onready var grow_visual: Node2D = $GrowVisual
@onready var plant_hint: Label = $PlantHint

func _ready() -> void:
	add_to_group("seed_points")
	collision_layer = 128
	collision_mask = 0
	
	if grow_visual:
		grow_visual.visible = false
	if plant_hint:
		plant_hint.visible = false
		
	EventBus.seed_planted.connect(_on_seed_planted_global)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if not is_planted and not is_grown and body.is_in_group("players") and body.get("player_id") == 2:
		if plant_hint:
			plant_hint.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players") and body.get("player_id") == 2:
		if plant_hint and not is_planted:
			plant_hint.visible = false

func _on_area_entered(area: Area2D) -> void:
	if not is_planted and not is_grown and area.name == "SeedDetector":
		if plant_hint:
			plant_hint.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "SeedDetector":
		if plant_hint and not is_planted:
			plant_hint.visible = false

func _on_seed_planted_global(posisi: Vector2) -> void:
	if is_planted or is_grown:
		return
	if global_position.distance_to(posisi) > 80.0:
		return
		
	is_planted = true
	if plant_hint:
		plant_hint.text = "Tumbuh..."
		plant_hint.visible = true
	
	if seed_visual:
		var tw := create_tween()
		tw.tween_property(seed_visual, "modulate", Color(1.0, 0.9, 0.2, 1.0), 0.5)
	
	var timer := get_tree().create_timer(grow_time)
	timer.timeout.connect(_on_grown)

func _on_grown() -> void:
	is_grown = true
	if plant_hint:
		plant_hint.visible = false
		
	if seed_visual:
		seed_visual.visible = false
	if grow_visual:
		grow_visual.visible = true
		grow_visual.scale = Vector2.ZERO
		var tw := create_tween()
		tw.tween_property(grow_visual, "scale", Vector2.ONE, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	EventBus.seed_grown.emit(global_position)
	_apply_bonus()
	_check_all_grown()

func _apply_bonus() -> void:
	# Heal 10 HP ke semua pemain
	for player in get_tree().get_nodes_in_group("players"):
		var health := player.get_node_or_null("Health")
		if health and health.has_method("heal"):
			health.heal(10.0)
	EventBus.show_prompt.emit("Benih mekar! Memulihkan 10 HP pemain.", 2)

func _check_all_grown() -> void:
	var seed_points := get_tree().get_nodes_in_group("seed_points")
	var all_done := true
	for sp in seed_points:
		if not sp.get("is_grown"):
			all_done = false
			break
			
	if all_done:
		var arena := get_tree().current_scene
		# Cari portal di scene tree
		for portal in get_tree().get_nodes_in_group("portals"):
			if portal.has_method("check_activation"):
				portal.check_activation()
