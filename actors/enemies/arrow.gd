extends Area2D

@export var kecepatan: float = 400.0
@export var damage: float = 8.0
@export var batas_umur: float = 3.0

var arah: Vector2 = Vector2.RIGHT
var aktif: bool = false
var umur: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_kena_body)
	area_entered.connect(_on_kena_area)
	matikan()

func _physics_process(delta: float) -> void:
	if not aktif:
		return

	#obah proyektil
	global_position += arah * kecepatan * delta
	umur += delta

	#cek batas umur
	if umur >= batas_umur:
		matikan()

func tembak(pos: Vector2, arah_tuju: Vector2, dmg: float = 8.0) -> void:
	global_position = pos
	arah = arah_tuju.normalized()
	damage = dmg
	umur = 0.0
	aktif = true
	visible = true
	monitoring = true
	monitorable = true
	rotation = arah.angle()

func matikan() -> void:
	aktif = false
	visible = false
	monitoring = false
	monitorable = false

func _on_kena_body(body: Node2D) -> void:
	if not aktif:
		return
	if body.is_in_group("players"):
		var health := body.get_node_or_null("Health")
		if health:
			health.take_damage(damage)
	matikan()

func _on_kena_area(area: Area2D) -> void:
	if not aktif:
		return
	if area.is_in_group("hurtboxes"):
		var pemilik := area.get_parent()
		if pemilik and pemilik.is_in_group("players"):
			var health := pemilik.get_node_or_null("Health")
			if health:
				health.take_damage(damage)
			matikan()
