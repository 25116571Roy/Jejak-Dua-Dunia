extends "res://actors/enemies/enemy_base.gd"

@export var scene_panah: PackedScene = preload("res://actors/enemies/arrow.tscn")
@export var jarak_minimal: float = 220.0
@export var jarak_maksimal: float = 280.0

var pool_panah: Array[Area2D] = []

func _ready() -> void:
	if not data:
		data = preload("res://data/enemy_data/archer_data.tres")
	durasi_windup = 1.0
	durasi_recover = 0.5
	super._ready()
	_siapkan_pool(5)
	_nonaktifkan_weakpoint()

func _siapkan_pool(jumlah: int) -> void:
	for i in range(jumlah):
		var p: Area2D = scene_panah.instantiate()
		add_child(p)
		p.matikan()
		pool_panah.append(p)

func _ambil_panah() -> Area2D:
	for p in pool_panah:
		if not p.aktif:
			return p
	var p_baru: Area2D = scene_panah.instantiate()
	add_child(p_baru)
	p_baru.matikan()
	pool_panah.append(p_baru)
	return p_baru

func _proses_gerak_idle(_delta: float) -> void:
	if not target_pemain or target_pemain.get("is_down") == true:
		velocity.x = 0.0
		pilih_target()
		return

	var beda_x: float = target_pemain.global_position.x - global_position.x
	var jarak: float = abs(beda_x)
	balik_arah(sign(beda_x))

	#jaga jarak tembak
	if jarak < jarak_minimal:
		velocity.x = -sign(beda_x) * kecepatan_gerak
	elif jarak > jarak_maksimal:
		velocity.x = sign(beda_x) * kecepatan_gerak
	else:
		velocity.x = 0.0

	if jarak <= jarak_maksimal + 50.0 and cd_serang <= 0.0:
		_mulai_windup()

func _mulai_windup() -> void:
	super._mulai_windup()
	#aktifkan weakpoint kepala saat tarik busur
	var wp := get_node_or_null("WeakpointArea")
	if wp:
		wp.monitoring = true
		wp.monitorable = true

func _mulai_serang() -> void:
	_nonaktifkan_weakpoint()
	super._mulai_serang()

	#tembak panah
	if target_pemain:
		var panah := _ambil_panah()
		var pos_tembak := global_position + Vector2(16.0 if hadap_kanan else -16.0, -10.0)
		var arah_tuju: Vector2 = (target_pemain.global_position - pos_tembak).normalized()
		panah.tembak(pos_tembak, arah_tuju, damage_serangan)
