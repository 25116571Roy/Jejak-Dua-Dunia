extends Area2D

signal hit_connected(target_hurtbox: Area2D)

@export var damage: float = 10.0
@export var stagger_damage: float = 20.0
@export var knockback_force: float = 200.0
@export var milik_pemain: bool = true

var is_active: bool = false

func _ready() -> void:
	add_to_group("hitboxes")
	monitoring = false
	_atur_layer()
	area_entered.connect(_on_area_masuk)

func _atur_layer() -> void:
	collision_layer = 0
	collision_mask = 0
	#pemain: layer 5, deteksi musuh di layer 4
	if milik_pemain:
		set_collision_layer_value(5, true)
		set_collision_mask_value(4, true)
	#musuh: layer 6, deteksi raka(2) dan nisa(3)
	else:
		set_collision_layer_value(6, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)

func activate() -> void:
	monitoring = true
	is_active = true

func deactivate() -> void:
	monitoring = false
	is_active = false

func _on_area_masuk(area: Area2D) -> void:
	if area.is_in_group("hurtboxes"):
		hit_connected.emit(area)
