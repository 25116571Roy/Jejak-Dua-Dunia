extends Area2D

signal hit_received(damage: float, direction: Vector2, knockback: float, stagger: float)

@export var hurtbox_type: String = "enemy"
@export var is_weakpoint: bool = false
@export var weakpoint_multiplier: float = 2.5

var owner_node: Node = null
var is_vulnerable: bool = true

func _ready() -> void:
	owner_node = owner
	add_to_group("hurtbox")

func set_vulnerable(vulnerable: bool) -> void:
	is_vulnerable = vulnerable

func receive_hit(damage: float, direction: Vector2, knockback: float, stagger: float) -> void:
	if not is_vulnerable:
		return
	
	if is_weakpoint:
		damage *= weakpoint_multiplier
	
	hit_received.emit(damage, direction, knockback, stagger)
