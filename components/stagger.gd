extends Node

signal stagger_full()
signal stagger_recovered()

@export var stagger_threshold: float = 100.0
@export var stagger_duration: float = 3.5
@export var stagger_decay_rate: float = 5.0

var current_stagger: float = 0.0
var is_staggered: bool = false
var stagger_timer: float = 0.0

func _process(delta: float) -> void:
	if is_staggered:
		stagger_timer -= delta
		if stagger_timer <= 0:
			recover_from_stagger()
	elif current_stagger > 0:
		current_stagger = max(0, current_stagger - stagger_decay_rate * delta)

func add_stagger(amount: float) -> void:
	if is_staggered:
		return
	
	current_stagger += amount
	
	if current_stagger >= stagger_threshold:
		trigger_stagger()

func trigger_stagger() -> void:
	is_staggered = true
	stagger_timer = stagger_duration
	current_stagger = 0.0
	stagger_full.emit()

func recover_from_stagger() -> void:
	is_staggered = false
	stagger_timer = 0.0
	stagger_recovered.emit()

func reset() -> void:
	current_stagger = 0.0
	is_staggered = false
	stagger_timer = 0.0

func get_stagger_percentage() -> float:
	return current_stagger / stagger_threshold
