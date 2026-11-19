extends Node

var combo_count: int = 0
var combo_timer: float = 0.0
var combo_timeout: float = 3.0
var max_combo: int = 0

signal combo_updated(count: int)
signal combo_broken()

func _ready() -> void:
	EventBus.parry_success.connect(_on_combo_action)
	EventBus.dash_performed.connect(_on_combo_action)
	EventBus.weakpoint_hit.connect(_on_combo_action_weakpoint)
	EventBus.finisher_performed.connect(_on_combo_action_finisher)

func _process(delta: float) -> void:
	if combo_count > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			break_combo()

func increase_combo() -> void:
	combo_count += 1
	combo_timer = combo_timeout
	
	if combo_count > max_combo:
		max_combo = combo_count
	
	combo_updated.emit(combo_count)

func break_combo() -> void:
	combo_count = 0
	combo_timer = 0.0
	combo_broken.emit()

func _on_combo_action(_player: Node) -> void:
	increase_combo()

func _on_combo_action_weakpoint(_enemy: Node, _damage: float) -> void:
	increase_combo()

func _on_combo_action_finisher(_player: Node, _enemy: Node) -> void:
	increase_combo()

func reset() -> void:
	combo_count = 0
	combo_timer = 0.0
	max_combo = 0

func get_max_combo() -> int:
	return max_combo
