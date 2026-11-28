extends CanvasLayer

@export var player_id: int = 1
@export var nama_karakter: String = "Raka"

@onready var bar_hp: ProgressBar = %BarHP
@onready var label_nama: Label = %LabelNama
@onready var bar_cd: ProgressBar = %BarCooldown
@onready var label_prompt: Label = %LabelPrompt
@onready var tanda_partner: Control = %TandaPartner
@onready var panah_partner: Control = %PanahPartner
@onready var label_jarak: Label = %LabelJarak
@onready var panel_down: Control = %PanelDown

var partner_node: Node2D = null

func _ready() -> void:
	label_nama.text = "%s (P%d)" % [nama_karakter, player_id]
	panel_down.hide()
	label_prompt.hide()
	tanda_partner.hide()

	EventBus.player_hp_changed.connect(_on_hp_changed)
	EventBus.show_prompt.connect(_on_prompt)
	EventBus.player_down.connect(_on_down)
	EventBus.player_revived.connect(_on_revived)
	_init_hp()

func _init_hp() -> void:
	await get_tree().process_frame
	var p := _cari_pemain(player_id)
	if p:
		var h := p.get_node_or_null("Health")
		if h and "hp_sekarang" in h and "hp_maks" in h:
			bar_hp.max_value = h.hp_maks
			bar_hp.value = h.hp_sekarang

func _process(_delta: float) -> void:
	#update partner
	_update_partner()
	_update_cooldown()

func _update_cooldown() -> void:
	var player := _cari_pemain(player_id)
	if not player:
		return
	if "cd_dash" in player:
		var cd: float = player.cd_dash
		var max_cd: float = player.cooldown_dash if "cooldown_dash" in player else 0.8
		bar_cd.max_value = max_cd
		bar_cd.value = max(max_cd - cd, 0.0)
	elif "cd_taunt" in player:
		var cd: float = player.cd_taunt
		var max_cd: float = player.cooldown_taunt if "cooldown_taunt" in player else 8.0
		bar_cd.max_value = max_cd
		bar_cd.value = max(max_cd - cd, 0.0)

func _update_partner() -> void:
	if not partner_node or not is_instance_valid(partner_node):
		partner_node = _cari_pemain(2 if player_id == 1 else 1)
		if not partner_node:
			tanda_partner.hide()
			return

	var cam := get_viewport().get_camera_2d()
	if not cam:
		tanda_partner.hide()
		return

	var screen_pos: Vector2 = cam.get_screen_center_position()
	var vp_size := get_viewport().get_visible_rect().size
	var half_size := vp_size * 0.5
	var screen_rect := Rect2(screen_pos - half_size, vp_size)

	#cek on screen
	var di_layar := screen_rect.has_point(partner_node.global_position)
	tanda_partner.visible = not di_layar

	if not di_layar:
		var arah: Vector2 = (partner_node.global_position - screen_pos).normalized()
		panah_partner.rotation = arah.angle()
		var jarak: float = screen_pos.distance_to(partner_node.global_position)
		label_jarak.text = "%.0f px" % jarak

func _cari_pemain(pid: int) -> Node2D:
	for p in get_tree().get_nodes_in_group("players"):
		if p is Node2D and p.get("player_id") == pid:
			return p
	for node in get_tree().root.find_children("*", "CharacterBody2D", true, false):
		if node.get("player_id") == pid:
			return node
	return null

func _on_hp_changed(pid: int, hp_sekarang: float, hp_maks: float) -> void:
	if pid != player_id:
		return
	bar_hp.max_value = hp_maks
	bar_hp.value = hp_sekarang

func _on_prompt(teks: String, pid: int) -> void:
	if pid != player_id and pid != 0:
		return
	label_prompt.text = teks
	label_prompt.show()
	await get_tree().create_timer(2.5).timeout
	label_prompt.hide()

func _on_down(pid: int) -> void:
	if pid == player_id:
		panel_down.show()

func _on_revived(pid: int) -> void:
	if pid == player_id:
		panel_down.hide()
