extends Control

@export var scene_level: PackedScene

@onready var vp_kiri: SubViewport = $HBoxContainer/VPContainerKiri/SubViewportKiri
@onready var vp_kanan: SubViewport = $HBoxContainer/VPContainerKanan/SubViewportKanan

var player2: Node = null
var kamera_p2: Camera2D = null

func _ready() -> void:
	vp_kanan.world_2d = vp_kiri.world_2d

	var res := get_node_or_null("ResultScreen")
	if res:
		res.lanjut_ditekan.connect(func(): SceneManager.ke_menu_utama())

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

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	#debug level complete (F1)
	if event.keycode == KEY_F1:
		EventBus.level_complete.emit(1)
	#debug simulasi damage (F2)
	elif event.keycode == KEY_F2:
		EventBus.player_hp_changed.emit(1, 60.0, 100.0)
		EventBus.player_hp_changed.emit(2, 45.0, 100.0)
	#debug simulasi heal (F3)
	elif event.keycode == KEY_F3:
		EventBus.player_hp_changed.emit(1, 100.0, 100.0)
		EventBus.player_hp_changed.emit(2, 100.0, 100.0)
