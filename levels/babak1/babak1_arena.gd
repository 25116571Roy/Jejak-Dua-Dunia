class_name Babak1Arena
extends Node2D

@onready var background: Node2D = $Background
var _seeds_grown_count: int = 0

func _ready() -> void:
	EventBus.seed_grown.connect(_on_seed_grown)
	if background:
		# Warna awal: hutan suram dan abu kehancuran
		background.modulate = Color(0.65, 0.65, 0.7, 1.0)

func _on_seed_grown(_pos: Vector2) -> void:
	_seeds_grown_count += 1
	if not background:
		return
		
	var target_color: Color = Color(0.65, 0.65, 0.7, 1.0)
	if _seeds_grown_count == 1:
		target_color = Color(0.75, 0.85, 0.75, 1.0)
	elif _seeds_grown_count == 2:
		target_color = Color(0.85, 0.95, 0.85, 1.0)
	elif _seeds_grown_count >= 3:
		target_color = Color(1.0, 1.15, 1.0, 1.0)
		
	var tw := create_tween()
	tw.tween_property(background, "modulate", target_color, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
