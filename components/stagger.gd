extends Node

signal staggered(durasi: float)
signal stagger_ended()
signal stagger_changed(sekarang: float, maks: float)

@export var stagger_maks: float = 100.0
@export var laju_pulih: float = 20.0
@export var durasi_pingsan: float = 3.5

var stagger_sekarang: float = 0.0
var sedang_pingsan: bool = false

func add_stagger(jumlah: float) -> void:
	if sedang_pingsan:
		return
	stagger_sekarang = min(stagger_sekarang + jumlah, stagger_maks)
	stagger_changed.emit(stagger_sekarang, stagger_maks)
	if stagger_sekarang >= stagger_maks:
		_pingsan()

func get_ratio() -> float:
	return stagger_sekarang / stagger_maks

func reset() -> void:
	stagger_sekarang = 0.0
	stagger_changed.emit(0.0, stagger_maks)

func _pingsan() -> void:
	sedang_pingsan = true
	stagger_sekarang = 0.0
	staggered.emit(durasi_pingsan)
	EventBus.enemy_staggered.emit(get_parent())
	await get_tree().create_timer(durasi_pingsan).timeout
	sedang_pingsan = false
	stagger_ended.emit()

func _process(delta: float) -> void:
	if sedang_pingsan or stagger_sekarang <= 0.0:
		return
	stagger_sekarang = max(stagger_sekarang - laju_pulih * delta, 0.0)
	stagger_changed.emit(stagger_sekarang, stagger_maks)
