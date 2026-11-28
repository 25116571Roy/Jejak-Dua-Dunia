extends CanvasLayer

signal lanjut_ditekan()

@onready var panel_hasil: Control = $PanelHasil
@onready var label_babak: Label = %LabelBabak
@onready var label_waktu: Label = %LabelWaktu
@onready var label_jatuh: Label = %LabelJatuh
@onready var tombol_lanjut: Button = %BtnLanjut

func _ready() -> void:
	panel_hasil.hide()
	tombol_lanjut.pressed.connect(_on_lanjut)
	EventBus.level_complete.connect(_on_level_complete)

func _on_level_complete(babak: int) -> void:
	var waktu: float = GameState.get("waktu_babak") if "waktu_babak" in GameState else 0.0
	var jatuh: int = int(GameState.get("jumlah_jatuh")) if "jumlah_jatuh" in GameState else 0
	tampil_hasil(babak, waktu, jatuh)

func tampil_hasil(babak: int, waktu: float, jatuh: int) -> void:
	label_babak.text = "BABAK %d SELESAI" % babak
	var menit: int = int(waktu) / 60
	var detik: int = int(waktu) % 60
	label_waktu.text = "Waktu: %02d:%02d" % [menit, detik]
	label_jatuh.text = "Jatuh: %d kali" % jatuh
	panel_hasil.show()

func _on_lanjut() -> void:
	panel_hasil.hide()
	lanjut_ditekan.emit()
