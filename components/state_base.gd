extends Node

var mesin: Node = null
var pemilik: Node = null

func _ready() -> void:
	pemilik = get_parent()

func masuk(_state_sebelum: String) -> void:
	pass

func keluar() -> void:
	pass

func update(_delta: float) -> void:
	pass

func update_fisika(_delta: float) -> void:
	pass
