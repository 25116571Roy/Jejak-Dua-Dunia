extends Node2D

@export var seed_grow_time: float = 6.0
@export var plant_scene: PackedScene

var is_seed_planted: bool = false
var grow_timer: float = 0.0

signal seed_planted(position: Vector2)
signal plant_grown(position: Vector2)

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if is_seed_planted:
		grow_timer += delta
		if grow_timer >= seed_grow_time:
			_grow_plant()

func plant_seed() -> void:
	if is_seed_planted:
		return
	
	is_seed_planted = true
	grow_timer = 0.0
	seed_planted.emit(global_position)
	
	EventBus.seed_planted.emit(global_position)

func _grow_plant() -> void:
	if plant_scene:
		var plant := plant_scene.instantiate()
		get_parent().add_child(plant)
		plant.global_position = global_position
	
	plant_grown.emit(global_position)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player2"):
		if body.has_method("can_plant_seed"):
			plant_seed()
