extends "res://actors/enemies/enemy_base.gd"

@export var damage_ringan: float = 10.0
@export var damage_berat: float = 18.0
@export var windup_ringan: float = 0.4
@export var windup_berat: float = 0.8

var tebas_berat: bool = false

func _ready() -> void:
	if not data:
		data = preload("res://data/enemy_data/swordsman_data.tres")
	durasi_recover = 0.5
	jarak_serang = 50.0
	super._ready()
	_nonaktifkan_weakpoint()
	var hitbox := get_node_or_null("Hitbox")
	if hitbox and hitbox.has_method("deactivate"):
		hitbox.deactivate()

func _mulai_windup() -> void:
	#acak tebas ringan (60%) atau tebas berat (40%)
	tebas_berat = (randf() < 0.4)
	durasi_windup = windup_berat if tebas_berat else windup_ringan
	damage_serangan = damage_berat if tebas_berat else damage_ringan

	super._mulai_windup()

func _mulai_serang() -> void:
	super._mulai_serang()

	#aktifkan hitbox pedang
	var hitbox := get_node_or_null("Hitbox")
	if hitbox:
		hitbox.damage = damage_serangan
		if hitbox.has_method("activate"):
			hitbox.activate()

	#weakpoint dada terbuka jika tebas berat
	if tebas_berat:
		var wp := get_node_or_null("WeakpointArea")
		if wp:
			wp.monitoring = true
			wp.monitorable = true

func _mulai_recover() -> void:
	#matikan hitbox saat masuk recovery
	var hitbox := get_node_or_null("Hitbox")
	if hitbox and hitbox.has_method("deactivate"):
		hitbox.deactivate()

	super._mulai_recover()
	#catatan: weakpoint dada tetap aktif selama durasi_recover jika tebas_berat
