class_name WaveData
extends Resource

@export var gelombang: Array[Dictionary] = []

var waves: Array[Dictionary]:
	get:
		return gelombang
	set(v):
		gelombang = v
