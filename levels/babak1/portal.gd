class_name Portal
extends Area2D

@export var babak_id: int = 1
var is_active: bool = false
var players_inside: Array = []

@onready var portal_visual: Node2D = $PortalVisual
@onready var status_label: Label = $StatusLabel

func _ready() -> void:
	add_to_group("portals")
	# Mask 6 = Layer 2 (Raka) + Layer 3 (Nisa)
	collision_layer = 128
	collision_mask = 6
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_update_visual()

func check_activation() -> void:
	if is_active:
		return
		
	var wave_manager := get_parent().get_node_or_null("WaveManager")
	var waves_ok: bool = false
	if wave_manager:
		waves_ok = wave_manager.get("all_waves_cleared")
	else:
		waves_ok = true
		
	var seed_points := get_tree().get_nodes_in_group("seed_points")
	var seeds_ok: bool = true
	if seed_points.size() > 0:
		for sp in seed_points:
			if not sp.get("is_grown"):
				seeds_ok = false
				break
				
	if waves_ok and seeds_ok:
		activate()

func activate() -> void:
	if is_active:
		return
	is_active = true
	_update_visual()
	EventBus.show_prompt.emit("Portal Aktif! Masuk bersama untuk melanjutkan.", 1)
	EventBus.show_prompt.emit("Portal Aktif! Masuk bersama untuk melanjutkan.", 2)

func _update_visual() -> void:
	if not portal_visual:
		return
	if is_active:
		portal_visual.modulate = Color(0.2, 0.9, 1.0, 1.0)
		if status_label:
			status_label.text = "PORTAL TERBUKA\n(Masuk Berdua)"
			status_label.modulate = Color(0.4, 1.0, 1.0, 1.0)
		var tw := create_tween().set_loops()
		tw.tween_property(portal_visual, "scale", Vector2(1.1, 1.1), 0.8).set_trans(Tween.TRANS_SINE)
		tw.tween_property(portal_visual, "scale", Vector2(0.95, 0.95), 0.8).set_trans(Tween.TRANS_SINE)
	else:
		portal_visual.modulate = Color(0.4, 0.4, 0.5, 0.6)
		if status_label:
			status_label.text = "Portal Terkunci\n(Kalahkan musuh & tanam benih)"
			status_label.modulate = Color(0.7, 0.7, 0.7, 0.7)

func _get_player_identifier(body: Node2D) -> Variant:
	var pid: Variant = body.get("player_id")
	if pid == null and body.has_meta("player_id"):
		pid = body.get_meta("player_id")
	if pid == null:
		pid = body.get_instance_id()
	return pid

func _on_body_entered(body: Node2D) -> void:
	if not is_active:
		return
	if body.is_in_group("players"):
		var pid: Variant = _get_player_identifier(body)
		if pid not in players_inside:
			players_inside.append(pid)
			
		if players_inside.size() >= 2:
			EventBus.level_complete.emit(babak_id)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		var pid: Variant = _get_player_identifier(body)
		players_inside.erase(pid)
