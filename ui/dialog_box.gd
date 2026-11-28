extends CanvasLayer

signal dialog_line_done()
signal dialog_selesai()

@onready var panel_dialog: Control = $PanelDialog
@onready var label_nama: Label = %LabelNama
@onready var label_teks: RichTextLabel = %LabelTeks
@onready var indikator_lanjut: Label = %IndikatorLanjut

var sedang_tampil: bool = false

func _ready() -> void:
	panel_dialog.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not sedang_tampil:
		return
	if event.is_action_pressed("p1_attack") or event.is_action_pressed("p2_attack") or event.is_action_pressed("ui_accept"):
		dialog_line_done.emit()

func tampil_dialog(nama: String, teks: String) -> void:
	label_nama.text = nama
	label_teks.text = teks
	sedang_tampil = true
	panel_dialog.show()

func tutup_dialog() -> void:
	sedang_tampil = false
	panel_dialog.hide()
	dialog_selesai.emit()
