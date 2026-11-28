extends Node

signal state_changed(state_lama: String, state_baru: String)

var _states: Dictionary = {}
var _state_aktif: Node = null

func tambah_state(state: Node) -> void:
	_states[state.name] = state
	state.mesin = self

func ganti_state(nama: String) -> void:
	if not _states.has(nama):
		return
	var lama := _state_aktif.name if _state_aktif else ""
	if _state_aktif:
		_state_aktif.keluar()
	_state_aktif = _states[nama]
	_state_aktif.masuk(lama)
	state_changed.emit(lama, nama)

func get_state() -> String:
	return _state_aktif.name if _state_aktif else ""

func update(delta: float) -> void:
	if _state_aktif:
		_state_aktif.update(delta)

func update_fisika(delta: float) -> void:
	if _state_aktif:
		_state_aktif.update_fisika(delta)
