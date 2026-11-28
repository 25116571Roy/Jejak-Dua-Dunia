extends Control

@onready var tombol_main: Button = %BtnMain
@onready var tombol_opsi: Button = %BtnOpsi
@onready var tombol_keluar: Button = %BtnKeluar
@onready var menu_opsi: Control = $OptionsMenu

func _ready() -> void:
	tombol_main.pressed.connect(_on_main)
	tombol_opsi.pressed.connect(_on_opsi)
	tombol_keluar.pressed.connect(_on_keluar)
	menu_opsi.hide()

func _on_main() -> void:
	SceneManager.pindah_scene("res://levels/LvlTestSplit.tscn")

func _on_opsi() -> void:
	menu_opsi.show()

func _on_keluar() -> void:
	get_tree().quit()
