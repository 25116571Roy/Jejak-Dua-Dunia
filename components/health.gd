extends Node

signal hp_changed(hp_sekarang: float, hp_maks: float)
signal died()

@export var hp_maks: float = 100.0
@export var durasi_kebal: float = 1.0

var hp_sekarang: float
var kebal: bool = false

func _ready() -> void:
	hp_sekarang = hp_maks

func take_damage(jumlah: float) -> void:
	if kebal:
		return
	hp_sekarang = max(hp_sekarang - jumlah, 0.0)
	hp_changed.emit(hp_sekarang, hp_maks)
	#beritahu HUD jika pemain
	var pemilik := get_parent()
	if pemilik.is_in_group("players"):
		EventBus.player_hp_changed.emit(pemilik.player_id, hp_sekarang, hp_maks)
	if hp_sekarang <= 0.0:
		died.emit()
	else:
		_mulai_kebal()

func heal(jumlah: float) -> void:
	hp_sekarang = min(hp_sekarang + jumlah, hp_maks)
	hp_changed.emit(hp_sekarang, hp_maks)
	var pemilik := get_parent()
	if pemilik.is_in_group("players"):
		EventBus.player_hp_changed.emit(pemilik.player_id, hp_sekarang, hp_maks)

func get_hp_ratio() -> float:
	return hp_sekarang / hp_maks

func _mulai_kebal() -> void:
	kebal = true
	await get_tree().create_timer(durasi_kebal).timeout
	kebal = false
