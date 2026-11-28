extends Node

var checkpoint_babak: int = 1
var checkpoint_fase: int = 1

func simpan_checkpoint(babak: int, fase: int) -> void:
	checkpoint_babak = babak
	checkpoint_fase = fase
	EventBus.checkpoint_reached.emit(babak, fase)

func save_checkpoint(babak: int, fase: int) -> void:
	simpan_checkpoint(babak, fase)
