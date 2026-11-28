class_name EnemyBase
extends CharacterBody2D

@export var data: EnemyData
@export var kecepatan_gerak: float = 100.0
@export var hp_maks: float = 60.0
@export var damage_serangan: float = 10.0
@export var jarak_serang: float = 60.0
@export var cooldown_serang: float = 1.0
@export var durasi_windup: float = 0.8
@export var durasi_recover: float = 0.5

var gravitasi: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_pemain: Node2D = null
var timer_target: float = 0.0
var interval_target: float = 2.5
var state: String = "idle"
var timer_state: float = 0.0
var cd_serang: float = 0.0
var hadap_kanan: bool = true
var bar_hp: ColorRect = null
var bar_serang: ColorRect = null
var bar_root: Control = null

func _ready() -> void:
	add_to_group("enemies")
	_setup_bar_ui()
	if data:
		hp_maks = data.hp_maks
		kecepatan_gerak = data.kecepatan_gerak
		damage_serangan = data.damage_serangan
		jarak_serang = data.jarak_serang
		cooldown_serang = data.cooldown_serang

	var health := get_node_or_null("Health")
	if health:
		health.hp_maks = hp_maks
		health.hp_sekarang = hp_maks
		health.died.connect(_on_mati)

	var stagger := get_node_or_null("Stagger")
	if stagger:
		stagger.staggered.connect(_on_pingsan)
		stagger.stagger_ended.connect(_on_pulih)

	EventBus.player_used_taunt.connect(_on_taunt)
	pilih_target()

func _physics_process(delta: float) -> void:
	#kondisi mati
	if state == "dead":
		if not is_on_floor():
			velocity.y += gravitasi * delta
		velocity.x = 0.0
		move_and_slide()
		return

	#gravitasi
	if not is_on_floor():
		velocity.y += gravitasi * delta

	#timer cooldown serang
	if cd_serang > 0.0:
		cd_serang -= delta

	#timer ganti target
	timer_target += delta
	if timer_target >= interval_target:
		timer_target = 0.0
		pilih_target()

	#proses state
	_update_ai(delta)

	move_and_slide()
	_update_bar_visual()

func _update_ai(delta: float) -> void:
	if state == "stagger":
		velocity.x = 0.0
		return

	if state == "windup":
		velocity.x = 0.0
		timer_state -= delta
		if timer_state <= 0.0:
			_mulai_serang()
		return

	if state == "attack":
		velocity.x = 0.0
		timer_state -= delta
		if timer_state <= 0.0:
			_mulai_recover()
		return

	if state == "recover":
		velocity.x = 0.0
		timer_state -= delta
		if timer_state <= 0.0:
			state = "idle"
			_nonaktifkan_weakpoint()
		return

	#state idle / gerak
	if state == "idle":
		_proses_gerak_idle(delta)

func _proses_gerak_idle(_delta: float) -> void:
	if not target_pemain or target_pemain.get("is_down") == true:
		velocity.x = 0.0
		pilih_target()
		return

	var beda_x: float = target_pemain.global_position.x - global_position.x
	var jarak: float = abs(beda_x)
	balik_arah(sign(beda_x))

	if jarak <= jarak_serang and cd_serang <= 0.0:
		_mulai_windup()
	else:
		velocity.x = sign(beda_x) * kecepatan_gerak

func _mulai_windup() -> void:
	state = "windup"
	timer_state = durasi_windup
	velocity.x = 0.0
	tampilkan_telegraph(true)
	EventBus.play_sfx_request.emit("enemy_windup")

func _mulai_serang() -> void:
	state = "attack"
	timer_state = 0.2
	cd_serang = cooldown_serang
	tampilkan_telegraph(false)

func _mulai_recover() -> void:
	state = "recover"
	timer_state = durasi_recover

func _nonaktifkan_weakpoint() -> void:
	var wp := get_node_or_null("WeakpointArea")
	if wp:
		wp.monitoring = false
		wp.monitorable = false

func pilih_target() -> void:
	var list_pemain := get_tree().get_nodes_in_group("players")
	var pemain_hidup: Array[Node2D] = []
	for p in list_pemain:
		if p is Node2D and p.get("is_down") != true:
			pemain_hidup.append(p)
	if pemain_hidup.is_empty():
		target_pemain = null
	else:
		target_pemain = pemain_hidup[randi() % pemain_hidup.size()]

func balik_arah(arah_x: float) -> void:
	if arah_x > 0.0:
		hadap_kanan = true
		_update_flip(1.0)
	elif arah_x < 0.0:
		hadap_kanan = false
		_update_flip(-1.0)

func _update_flip(arah: float) -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite:
		sprite.flip_h = (arah < 0.0)
	var hitbox := get_node_or_null("Hitbox")
	if hitbox:
		hitbox.position.x = abs(hitbox.position.x) * arah
	var wp := get_node_or_null("WeakpointArea")
	if wp:
		wp.position.x = abs(wp.position.x) * arah

func tampilkan_telegraph(aktif: bool) -> void:
	var tanda := get_node_or_null("Telegraph")
	if tanda:
		tanda.visible = aktif

func _on_taunt(player_id: int, pos: Vector2, radius: float) -> void:
	if global_position.distance_to(pos) <= radius:
		for p in get_tree().get_nodes_in_group("players"):
			if p.get("player_id") == player_id and p is Node2D:
				target_pemain = p
				break

func _on_pingsan(_durasi: float) -> void:
	state = "stagger"
	velocity = Vector2.ZERO
	tampilkan_telegraph(false)
	_nonaktifkan_weakpoint()
	var hitbox := get_node_or_null("Hitbox")
	if hitbox and hitbox.has_method("deactivate"):
		hitbox.deactivate()

func _on_pulih() -> void:
	if state == "stagger":
		state = "idle"

func _on_mati() -> void:
	state = "dead"
	velocity = Vector2.ZERO
	tampilkan_telegraph(false)
	_nonaktifkan_weakpoint()
	EventBus.enemy_died.emit(self)
	var col := get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)
	await get_tree().create_timer(0.6).timeout
	queue_free()

func _setup_bar_ui() -> void:
	bar_root = Control.new()
	bar_root.name = "BarInfo"
	bar_root.position = Vector2(-20, -34)
	add_child(bar_root)

	#bg bar hp
	var bg_hp := ColorRect.new()
	bg_hp.size = Vector2(40, 5)
	bg_hp.color = Color(0.1, 0.1, 0.1, 0.8)
	bar_root.add_child(bg_hp)

	#isi bar hp
	bar_hp = ColorRect.new()
	bar_hp.size = Vector2(40, 5)
	bar_hp.color = Color(0.85, 0.2, 0.2)
	bar_root.add_child(bar_hp)

	#bg bar serang
	var bg_serang := ColorRect.new()
	bg_serang.position = Vector2(0, 6)
	bg_serang.size = Vector2(40, 4)
	bg_serang.color = Color(0.1, 0.1, 0.1, 0.8)
	bar_root.add_child(bg_serang)

	#isi bar serang
	bar_serang = ColorRect.new()
	bar_serang.position = Vector2(0, 6)
	bar_serang.size = Vector2(0, 4)
	bar_serang.color = Color(1.0, 0.85, 0.2)
	bar_root.add_child(bar_serang)

func _update_bar_visual() -> void:
	if not bar_root:
		return
	if state == "dead":
		bar_root.hide()
		return

	#update hp
	var health := get_node_or_null("Health")
	if health and bar_hp:
		var rasio: float = clamp(health.hp_sekarang / health.hp_maks, 0.0, 1.0)
		bar_hp.size.x = 40.0 * rasio

	#update bar serang
	if bar_serang:
		if state == "windup":
			var maks_w: float = max(durasi_windup, 0.01)
			var kemajuan: float = clamp(1.0 - (timer_state / maks_w), 0.0, 1.0)
			bar_serang.size.x = 40.0 * kemajuan
			bar_serang.color = Color(1.0, 0.85, 0.2)
		elif state == "attack":
			bar_serang.size.x = 40.0
			bar_serang.color = Color(1.0, 0.2, 0.2)
		else:
			bar_serang.size.x = 0.0
