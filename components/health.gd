extends Node

signal died()

@export var hp_maks: float = 100.0

var hp_sekarang: float

func _ready() -> void:
	hp_sekarang = hp_maks

func ambil_damage(jumlah: float) -> void:
	hp_sekarang = max(hp_sekarang - jumlah, 0.0)
	if hp_sekarang <= 0.0:
		died.emit()

func get_hp() -> float:
	return hp_sekarang
