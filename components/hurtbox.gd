extends Area2D

signal hit_received(damage: float)

func _ready() -> void:
	area_entered.connect(_on_area_masuk)

func _on_area_masuk(area) -> void:
	if area.is_active:
		hit_received.emit(area.damage)
