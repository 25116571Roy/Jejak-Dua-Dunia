extends "res://actors/player/player_base.gd"

@export var data: PlayerData
@export var kecepatan: float = 230.0
@export var kekuatan_lompat: float = -640.0
@export var damage_serangan: float = 20.0
@export var damage_finisher: float = 60.0
@export var durasi_parry: float = 0.25
@export var cooldown_parry: float = 1.0
@export var counter_multiplier: float = 2.5
@export var radius_taunt: float = 260.0
@export var durasi_taunt: float = 4.0
@export var cooldown_taunt: float = 6.0
@export var durasi_revive: float = 2.0
@export var durasi_serang: float = 0.35
@export var batas_level: Rect2 = Rect2(0, 0, 1280, 720)

var gravitasi: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var posisi_spawn: Vector2
var state: String = "idle"
var hadap_kanan: bool = true
var timer_serang: float = 0.0
var timer_parry: float = 0.0
var cd_parry: float = 0.0
var timer_taunt: float = 0.0
var cd_taunt: float = 0.0
var counter_aktif: bool = false
var timer_counter: float = 0.0
var timer_chain: float = 0.0
var target_chain: Node = null
var timer_revive: float = 0.0
var target_revive: Node = null

func _ready() -> void:
	player_id = 1
	super._ready()
	posisi_spawn = global_position
	if data:
		kecepatan = data.kecepatan
		kekuatan_lompat = data.kekuatan_lompat
		damage_serangan = data.damage_serangan
		damage_finisher = data.damage_finisher
		durasi_parry = data.durasi_parry
		cooldown_parry = data.cooldown_parry
		radius_taunt = data.radius_taunt
		durasi_taunt = data.durasi_taunt
		cooldown_taunt = data.cooldown_taunt
		durasi_revive = data.durasi_revive

	var health := get_node_or_null("Health")
	if health:
		health.hp_maks = 100.0
		health.died.connect(_mati)

	var hurtbox := get_node_or_null("HurtboxRaka")
	if hurtbox:
		hurtbox.hit_received.connect(_on_kena_hit)

	var revive_area := get_node_or_null("ReviveArea")
	if revive_area:
		revive_area.body_entered.connect(_revive_masuk)
		revive_area.body_exited.connect(_revive_keluar)

	EventBus.player_revived.connect(_di_revive)

func _physics_process(delta: float) -> void:
	#gravitasi
	if not is_on_floor():
		velocity.y += gravitasi * delta

	#cooldown
	if cd_parry > 0.0:
		cd_parry -= delta
	if cd_taunt > 0.0:
		cd_taunt -= delta
	if counter_aktif:
		timer_counter -= delta
		if timer_counter <= 0.0:
			counter_aktif = false

	#proses revive partner
	if target_revive and target_revive.get("is_down") == true and not is_down:
		timer_revive += delta
		if timer_revive >= durasi_revive:
			target_revive.set("is_down", false)
			var h := target_revive.get_node_or_null("Health")
			if h and h.has_method("heal"):
				h.heal(h.hp_maks * 0.25)
			EventBus.player_revived.emit(target_revive.get("player_id"))
			timer_revive = 0.0
	else:
		timer_revive = 0.0

	#cek batas level
	if not batas_level.has_point(global_position):
		global_position = posisi_spawn
		velocity = Vector2.ZERO

	#prompt finisher saat musuh pingsan
	var musuh_stagger := cari_musuh_stagger()
	if musuh_stagger and not is_down:
		EventBus.show_prompt.emit("Tekan T!", player_id)

	#proses state
	match state:
		"down":
			velocity.x = 0.0
		"hurt":
			velocity.x = move_toward(velocity.x, 0.0, 500.0 * delta)
		"parry":
			velocity.x = 0.0
			timer_parry -= delta
			if timer_parry <= 0.0:
				state = "idle"
				_reset_modulate()
		"taunt":
			velocity.x = 0.0
			timer_taunt -= delta
			if timer_taunt <= 0.0:
				state = "idle"
		"chain":
			velocity.x = 0.0
			timer_chain -= delta
			if timer_chain <= 0.0:
				state = "idle"
				if target_chain:
					EventBus.chain_anchor_released.emit(target_chain)
					target_chain = null
		"finisher":
			velocity.x = 0.0
			timer_serang -= delta
			if timer_serang <= 0.0:
				state = "idle"
				_selesai_serang()
		"attack":
			velocity.x = move_toward(velocity.x, 0.0, 300.0 * delta)
			timer_serang -= delta
			if timer_serang <= 0.0:
				state = "idle"
				_selesai_serang()
		"idle", "run", "jump", "fall":
			_proses_gerak(delta)

	move_and_slide()

func _proses_gerak(_delta: float) -> void:
	if is_down:
		return

	var arah := Input.get_axis(aksi_kiri, aksi_kanan)
	velocity.x = arah * kecepatan

	if arah != 0.0:
		hadap_kanan = (arah > 0.0)
		_balik_hitbox(1.0 if hadap_kanan else -1.0)
		var sprite := get_node_or_null("Sprite2D")
		if sprite:
			sprite.flip_h = not hadap_kanan

	#lompat
	if Input.is_action_just_pressed(aksi_loncat) and is_on_floor():
		velocity.y = kekuatan_lompat
		state = "jump"

	#serang
	if Input.is_action_just_pressed(aksi_serang):
		_mulai_serang()
		return

	#parry (H)
	if Input.is_action_just_pressed(aksi_spesial1) and cd_parry <= 0.0:
		_mulai_parry()
		return

	#taunt (G)
	if Input.is_action_just_pressed(aksi_spesial2) and cd_taunt <= 0.0:
		_mulai_taunt()
		return

	#finisher / chain (T)
	if Input.is_action_just_pressed(aksi_finisher):
		var musuh := cari_musuh_stagger()
		if musuh:
			_mulai_finisher(musuh)
			return
		var anchor := cari_chain_anchor()
		if anchor:
			_mulai_chain(anchor)
			return

	#update state visual
	if not is_on_floor():
		state = "jump" if velocity.y < 0.0 else "fall"
	else:
		state = "run" if abs(velocity.x) > 10.0 else "idle"

func _mulai_serang() -> void:
	state = "attack"
	timer_serang = durasi_serang
	var dmg := damage_serangan
	if counter_aktif:
		dmg *= counter_multiplier
		counter_aktif = false
	var hitbox := get_node_or_null("HitboxRaka")
	if hitbox:
		hitbox.damage = dmg
		hitbox.activate()

func _selesai_serang() -> void:
	var hitbox := get_node_or_null("HitboxRaka")
	if hitbox and hitbox.has_method("deactivate"):
		hitbox.deactivate()

func _mulai_parry() -> void:
	state = "parry"
	timer_parry = durasi_parry
	cd_parry = cooldown_parry
	var sprite := get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = Color(0.4, 0.7, 1.0)
	var health := get_node_or_null("Health")
	if health:
		health.kebal = true

func _mulai_taunt() -> void:
	state = "taunt"
	timer_taunt = 0.5
	cd_taunt = cooldown_taunt
	EventBus.player_used_taunt.emit(player_id, global_position, radius_taunt)
	var sprite := get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = Color(1.0, 0.9, 0.3)
		await get_tree().create_timer(0.4).timeout
		_reset_modulate()

func _mulai_finisher(musuh: Node) -> void:
	state = "finisher"
	timer_serang = 0.4
	var hitbox := get_node_or_null("HitboxRaka")
	if hitbox:
		hitbox.damage = damage_finisher
		hitbox.activate()
	EventBus.finisher_hit.emit(player_id, musuh)
	#hit-stop
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.015, false).timeout
	Engine.time_scale = 1.0

func _mulai_chain(anchor: Node) -> void:
	state = "chain"
	target_chain = anchor
	timer_chain = 3.5
	EventBus.chain_anchor_connected.emit(anchor)

func cari_musuh_stagger() -> Node:
	for b in get_tree().get_nodes_in_group("enemies"):
		if b is Node2D and global_position.distance_to(b.global_position) <= 100.0:
			var stagger: Node = b.get_node_or_null("Stagger")
			if stagger and stagger.get("sedang_pingsan") == true:
				return b
	return null

func cari_chain_anchor() -> Node:
	for a in get_tree().get_nodes_in_group("chain_anchors"):
		if a is Node2D and global_position.distance_to(a.global_position) <= 120.0:
			return a
	return null

func _balik_hitbox(arah: float) -> void:
	var hitbox := get_node_or_null("HitboxRaka")
	if hitbox:
		hitbox.position.x = abs(hitbox.position.x) * arah

func _reset_modulate() -> void:
	var sprite := get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var health := get_node_or_null("Health")
	if health:
		health.kebal = false

func _on_kena_hit(hitbox: Area2D, _dmg: float) -> void:
	if state == "parry":
		state = "idle"
		timer_parry = 0.0
		counter_aktif = true
		timer_counter = 1.0
		_reset_modulate()
		var penyerang := hitbox.get_parent()
		var stagger := penyerang.get_node_or_null("Stagger")
		if stagger and stagger.has_method("add_stagger"):
			stagger.add_stagger(30.0)
		EventBus.parry_success.emit(player_id)
		EventBus.play_sfx_request.emit("parry_success")
		return

	state = "hurt"
	_reset_modulate()
	await get_tree().create_timer(0.4).timeout
	if state == "hurt":
		state = "idle"

func _mati() -> void:
	is_down = true
	state = "down"
	velocity = Vector2.ZERO
	_reset_modulate()
	EventBus.player_down.emit(player_id)

func _di_revive(pid: int) -> void:
	if pid == player_id:
		is_down = false
		state = "idle"
		_reset_modulate()

func _revive_masuk(b: Node2D) -> void:
	if b.is_in_group("players") and b != self:
		target_revive = b
		timer_revive = 0.0

func _revive_keluar(b: Node2D) -> void:
	if b == target_revive:
		target_revive = null
		timer_revive = 0.0
