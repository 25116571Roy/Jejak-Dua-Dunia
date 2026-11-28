extends Control

signal kembali_ditekan()

@onready var slider_master: HSlider = %SliderMaster
@onready var slider_musik: HSlider = %SliderMusik
@onready var slider_sfx: HSlider = %SliderSFX
@onready var slider_ui: HSlider = %SliderUI
@onready var tombol_kembali: Button = %BtnKembali

var file_cfg: String = "user://settings.cfg"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	slider_master.value_changed.connect(_on_master_changed)
	slider_musik.value_changed.connect(_on_musik_changed)
	slider_sfx.value_changed.connect(_on_sfx_changed)
	slider_ui.value_changed.connect(_on_ui_changed)
	tombol_kembali.pressed.connect(_on_kembali)
	muat_pengaturan()

func _on_master_changed(val: float) -> void:
	_atur_volume("Master", val)

func _on_musik_changed(val: float) -> void:
	_atur_volume("Music", val)

func _on_sfx_changed(val: float) -> void:
	_atur_volume("SFX", val)

func _on_ui_changed(val: float) -> void:
	_atur_volume("UI", val)

func _atur_volume(nama_bus: String, nilai: float) -> void:
	var idx := AudioServer.get_bus_index(nama_bus)
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, linear_to_db(max(nilai, 0.0001)))
		AudioServer.set_bus_mute(idx, nilai <= 0.0)

func _on_kembali() -> void:
	simpan_pengaturan()
	hide()
	kembali_ditekan.emit()

func simpan_pengaturan() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master", slider_master.value)
	cfg.set_value("audio", "music", slider_musik.value)
	cfg.set_value("audio", "sfx", slider_sfx.value)
	cfg.set_value("audio", "ui", slider_ui.value)
	cfg.save(file_cfg)

func muat_pengaturan() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(file_cfg) == OK:
		slider_master.value = cfg.get_value("audio", "master", 0.8)
		slider_musik.value = cfg.get_value("audio", "music", 0.8)
		slider_sfx.value = cfg.get_value("audio", "sfx", 0.8)
		slider_ui.value = cfg.get_value("audio", "ui", 0.8)
	else:
		slider_master.value = 0.8
		slider_musik.value = 0.8
		slider_sfx.value = 0.8
		slider_ui.value = 0.8
