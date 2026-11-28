extends CanvasLayer

@onready var panel_pause: Control = $PanelPause
@onready var menu_opsi: Control = $OptionsMenu
@onready var tombol_lanjut: Button = %BtnLanjut
@onready var tombol_opsi: Button = %BtnOpsi
@onready var tombol_menu: Button = %BtnMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel_pause.hide()
	menu_opsi.hide()
	tombol_lanjut.pressed.connect(_on_lanjut)
	tombol_opsi.pressed.connect(_on_opsi)
	tombol_menu.pressed.connect(_on_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_pause") or event.is_action_pressed("p2_pause"):
		toggle_pause()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		toggle_pause()

func toggle_pause() -> void:
	if menu_opsi.visible:
		menu_opsi.hide()
		return
	var jeda := not get_tree().paused
	get_tree().paused = jeda
	panel_pause.visible = jeda

func _on_lanjut() -> void:
	get_tree().paused = false
	panel_pause.hide()

func _on_opsi() -> void:
	menu_opsi.show()

func _on_menu() -> void:
	get_tree().paused = false
	panel_pause.hide()
	SceneManager.ke_menu_utama()
