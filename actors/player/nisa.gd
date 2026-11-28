extends "res://actors/player/player_base.gd"

@export var data: PlayerData
@export var kecepatan: float = 340.0
@export var kekuatan_lompat: float = -700.0
@export var potong_lompat: float = -330.0
@export var damage_serangan: float = 9.0
@export var kecepatan_dash: float = 760.0
@export var durasi_dash: float = 0.16
@export var cooldown_dash: float = 0.8
@export var bonus_weakpoint: float = 2.5
@export var bonus_belakang: float = 1.8
@export var bonus_dash: float = 1.4
@export var bounce_udara: float = -200.0
@export var batas_level: Rect2 = Rect2()
@export var durasi_revive: float = 2.0
@export var durasi_serang: float = 0.2
@export var durasi_tanam: float = 0.5

var gravitasi: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var posisi_spawn: Vector2
var state: String = "idle"
var hadap_kanan: bool = true
var bisa_air_dash: bool = true
var timer_dash: float = 0.0
var cd_dash: float = 0.0
var arah_dash: Vector2 = Vector2.RIGHT
var timer_serang: float = 0.0
var timer_tanam: float = 0.0
var timer_revive: float = 0.0
var target_revive: Node = null
var titik_benih: Node = null
var dari_dash: bool = false

func _ready() -> void:
	player_id = 2
	super._ready()
	posisi_spawn = global_position
	if data:
		kecepatan = data.kecepatan
		kekuatan_lompat = data.kekuatan_lompat
		damage_serangan = data.damage_serangan
		kecepatan_dash = data.kecepatan_dash
		durasi_dash = data.durasi_dash
		cooldown_dash = data.cooldown_dash
		durasi_revive = data.durasi_revive

	var health := get_node_or_null("Health")
	if health:
		health.died.connect(_mati)

	var hitbox := get_node_or_null("HitboxNisa")
	if hitbox:
		hitbox.hit_connected.connect(_kena_musuh)

	var revive_area := get_node_or_null("ReviveArea")
	if revive_area:
		revive_area.body_entered.connect(_revive_masuk)
		revive_area.body_exited.connect(_revive_keluar)

	var seed_detector := get_node_or_null("SeedDetector")
	if seed_detector:
		seed_detector.area_entered.connect(_benih_masuk)
		seed_detector.area_exited.connect(_benih_keluar)

	EventBus.player_revived.connect(_di_revive)

func _physics_process(delta: float) -> void:
	#kondisi down
	if is_down:
		if not is_on_floor():
			velocity.y += gravitasi * delta
		velocity.x = 0.0
		move_and_slide()
		return

	#timer cooldown dash
	if cd_dash > 0.0:
		cd_dash -= delta

	#cek revive
	if target_revive and target_revive.get("is_down") == true:
		timer_revive += delta
		if timer_revive >= durasi_revive:
			target_revive.set("is_down", false)
			if "state" in target_revive:
				target_revive.set("state", "idle")
			var h := target_revive.get_node_or_null("Health")
			if h:
				h.heal(h.hp_maks * 0.25)
			var pid: int = int(target_revive.get("player_id")) if target_revive.get("player_id") != null else 1
			EventBus.player_revived.emit(pid)
			target_revive = null
			timer_revive = 0.0
	else:
		timer_revive = 0.0

	#tanam benih
	if state == "seed":
		velocity = Vector2.ZERO
		timer_tanam -= delta
		if timer_tanam <= 0.0:
			state = "idle"
		move_and_slide()
		return

	#input tanam benih
	if Input.is_action_just_pressed(aksi_spesial2) and titik_benih and is_on_floor() and state != "dash" and state != "attack":
		state = "seed"
		timer_tanam = durasi_tanam
		velocity = Vector2.ZERO
		EventBus.seed_planted.emit(global_position)
		move_and_slide()
		return

	#proses dash
	if state == "dash":
		timer_dash -= delta
		velocity = arah_dash * kecepatan_dash
		if Input.is_action_just_pressed(aksi_serang):
			_serang(true)
		elif timer_dash <= 0.0:
			state = "fall" if not is_on_floor() else "idle"
			var hurtbox := get_node_or_null("HurtboxNisa")
			if hurtbox:
				hurtbox.monitorable = true
			var health := get_node_or_null("Health")
			if health:
				health.kebal = false
		move_and_slide()
		return

	#input dash
	if Input.is_action_just_pressed(aksi_spesial1) and cd_dash <= 0.0 and state != "attack":
		var di_udara := not is_on_floor()
		if not di_udara or bisa_air_dash:
			if di_udara:
				bisa_air_dash = false
			state = "dash"
			timer_dash = durasi_dash
			cd_dash = cooldown_dash
			var ix := Input.get_axis(aksi_kiri, aksi_kanan)
			var iy := Input.get_axis(aksi_loncat, aksi_bawah)
			var input_dir := Vector2(ix, iy)
			if input_dir.length_squared() > 0.1:
				arah_dash = input_dir.normalized()
			else:
				arah_dash = Vector2.RIGHT if hadap_kanan else Vector2.LEFT
			var hurtbox := get_node_or_null("HurtboxNisa")
			if hurtbox:
				hurtbox.monitorable = false
			var health := get_node_or_null("Health")
			if health:
				health.kebal = true
			velocity = arah_dash * kecepatan_dash
			move_and_slide()
			return

	#proses serang
	if state == "attack":
		timer_serang -= delta
		if timer_serang <= 0.0:
			var hitbox := get_node_or_null("HitboxNisa")
			if hitbox:
				hitbox.deactivate()
			state = "idle" if is_on_floor() else "fall"
			dari_dash = false

	#input serang
	if Input.is_action_just_pressed(aksi_serang) and state != "attack" and state != "seed":
		_serang(false)

	#gravitasi
	if not is_on_floor():
		velocity.y += gravitasi * delta
	else:
		bisa_air_dash = true

	#lompat variabel
	if Input.is_action_just_pressed(aksi_loncat) and is_on_floor() and state != "attack":
		velocity.y = kekuatan_lompat
		state = "jump"

	if Input.is_action_just_released(aksi_loncat) and velocity.y < potong_lompat:
		velocity.y = potong_lompat

	if not is_on_floor() and velocity.y > 0.0 and state != "attack":
		state = "fall"

	#obah horizontal
	var arah := Input.get_axis(aksi_kiri, aksi_kanan)
	velocity.x = arah * kecepatan
	if arah > 0.0:
		hadap_kanan = true
		$Sprite2D.flip_h = false
		_balik_hitbox(1.0)
	elif arah < 0.0:
		hadap_kanan = false
		$Sprite2D.flip_h = true
		_balik_hitbox(-1.0)

	if is_on_floor() and state != "attack":
		if abs(velocity.x) > 10.0:
			state = "run"
		else:
			state = "idle"

	move_and_slide()

	if (batas_level.size != Vector2.ZERO and not batas_level.has_point(global_position)) or global_position.y > 2500.0:
		respawn()

func respawn() -> void:
	global_position = posisi_spawn
	velocity = Vector2.ZERO

func _serang(lewat_dash: bool) -> void:
	state = "attack"
	timer_serang = durasi_serang
	dari_dash = lewat_dash
	var hitbox := get_node_or_null("HitboxNisa")
	if hitbox:
		hitbox.damage = damage_serangan * (bonus_dash if dari_dash else 1.0)
		hitbox.activate()

func _kena_musuh(hurtbox_musuh: Area2D) -> void:
	var musuh := hurtbox_musuh.get_parent()
	var pengali := 1.0

	#cek weakpoint
	var kena_weakpoint := false
	if hurtbox_musuh.is_in_group("weakpoints") or hurtbox_musuh.name.to_lower().contains("weakpoint") or hurtbox_musuh.get("is_weakpoint") == true:
		kena_weakpoint = true
	else:
		var detector := get_node_or_null("WeakpointDetector")
		if detector:
			for a in detector.get_overlapping_areas():
				if a.is_in_group("weakpoints") or a.name.to_lower().contains("weakpoint") or a.get("is_weakpoint") == true:
					kena_weakpoint = true
					break

	if kena_weakpoint:
		pengali = bonus_weakpoint
	elif _cek_belakang(musuh):
		pengali = bonus_belakang
	elif dari_dash:
		pengali = bonus_dash

	var total_damage := damage_serangan * pengali
	var base_applied := damage_serangan * (bonus_dash if dari_dash else 1.0)
	var selisih := total_damage - base_applied
	if selisih > 0.0:
		var health := musuh.get_node_or_null("Health")
		if health:
			health.take_damage(selisih)

	if kena_weakpoint:
		EventBus.weakpoint_hit.emit(musuh, total_damage)

	#bounce udara
	if not is_on_floor():
		velocity.y = bounce_udara

func _cek_belakang(musuh: Node2D) -> bool:
	var arah_musuh: float = 1.0
	if "hadap_kanan" in musuh:
		arah_musuh = 1.0 if musuh.get("hadap_kanan") else -1.0
	elif musuh is CharacterBody2D and abs(musuh.velocity.x) > 0.1:
		arah_musuh = sign(musuh.velocity.x)
	var beda_x: float = global_position.x - musuh.global_position.x
	return (arah_musuh > 0.0 and beda_x < 0.0) or (arah_musuh < 0.0 and beda_x > 0.0)

func _balik_hitbox(arah: float) -> void:
	var hitbox := get_node_or_null("HitboxNisa")
	if hitbox:
		hitbox.position.x = abs(hitbox.position.x) * arah
	var detector := get_node_or_null("WeakpointDetector")
	if detector:
		detector.position.x = abs(detector.position.x) * arah

func _mati() -> void:
	is_down = true
	state = "down"
	velocity = Vector2.ZERO
	EventBus.player_down.emit(player_id)

func _di_revive(pid: int) -> void:
	if pid == player_id:
		is_down = false
		state = "idle"

func _revive_masuk(b: Node2D) -> void:
	if b.is_in_group("players") and b != self:
		target_revive = b
		timer_revive = 0.0

func _revive_keluar(b: Node2D) -> void:
	if b == target_revive:
		target_revive = null
		timer_revive = 0.0

func _benih_masuk(area: Area2D) -> void:
	if area.is_in_group("seed_points"):
		titik_benih = area

func _benih_keluar(area: Area2D) -> void:
	if area == titik_benih:
		titik_benih = null
