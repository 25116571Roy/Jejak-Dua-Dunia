extends Control

@export var scene_level: PackedScene

@onready var vp_kiri: SubViewport = $HBoxContainer/VPContainerKiri/SubViewportKiri
@onready var vp_kanan: SubViewport = $HBoxContainer/VPContainerKanan/SubViewportKanan

var player2: Node = null
var kamera_p2: Camera2D = null

func _ready() -> void:
	vp_kanan.world_2d = vp_kiri.world_2d

	if not scene_level:
		return

	var level := scene_level.instantiate()
	vp_kiri.add_child(level)

	await get_tree().process_frame
	_setup_kamera_p2(level)

func _setup_kamera_p2(level: Node) -> void:
	#cari CharacterBody2D dengan player_id == 2 tanpa butuh group
	for node in level.find_children("*", "CharacterBody2D", true, false):
		if node.get("player_id") == 2:
			player2 = node
			break

	if not player2:
		return

	#nonaktifkan kamera p2 yang ada di vp_kiri (biar tidak bentrok)
	var cam_lama := player2.get_node_or_null("Camera2D")
	if cam_lama:
		cam_lama.enabled = false

	#buat kamera baru langsung di vp_kanan, sync posisi tiap frame di _process
	kamera_p2 = Camera2D.new()
	kamera_p2.enabled = true
	vp_kanan.add_child(kamera_p2)

func _process(_delta: float) -> void:
	if player2 and kamera_p2:
		kamera_p2.global_position = player2.global_position
