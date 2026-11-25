extends Area2D

signal hit_connected(target)

@export var damage: float = 10.0
var is_active: bool = false

func _ready() -> void:
	monitoring = false

func aktifkan() -> void:
	monitoring = true
	is_active = true

func nonaktifkan() -> void:
	monitoring = false
	is_active = false
