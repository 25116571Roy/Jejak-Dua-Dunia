extends CharacterBody2D

@export var player_id: int = 1

var is_down: bool = false

var aksi_kiri: String
var aksi_kanan: String
var aksi_loncat: String
var aksi_bawah: String
var aksi_serang: String
var aksi_spesial1: String
var aksi_spesial2: String
var aksi_finisher: String

func _ready() -> void:
	add_to_group("players")
	aksi_kiri = "p%d_left" % player_id
	aksi_kanan = "p%d_right" % player_id
	aksi_loncat = "p%d_jump" % player_id
	aksi_bawah = "p%d_down" % player_id
	aksi_serang = "p%d_attack" % player_id
	aksi_spesial1 = "p%d_special1" % player_id
	aksi_spesial2 = "p%d_special2" % player_id
	aksi_finisher = "p%d_finisher" % player_id
