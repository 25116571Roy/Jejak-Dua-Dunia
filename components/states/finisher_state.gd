class_name FinisherState
extends State

@export var finisher_duration: float = 1.0

var timer: float = 0.0
var target_enemy: Node = null

func enter() -> void:
	timer = finisher_duration
	if actor.has_method("play_animation"):
		actor.play_animation("finisher")
	
	_find_staggered_enemy()
	_perform_finisher()

func _find_staggered_enemy() -> void:
	var finisher_range: float = 150.0
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_node("Stagger"):
			var stagger_component := enemy.get_node("Stagger")
			if stagger_component.is_staggered:
				var distance := actor.global_position.distance_to(enemy.global_position)
				if distance <= finisher_range:
					target_enemy = enemy
					break

func _perform_finisher() -> void:
	if not target_enemy:
		return
	
	var finisher_damage: float = 60.0
	
	if target_enemy.has_method("take_damage"):
		target_enemy.take_damage(finisher_damage, Vector2.ZERO, 0.0, 0.0)
	
	EventBus.emit_finisher_performed(actor, target_enemy)

func physics_update(delta: float) -> void:
	timer -= delta
	
	if timer <= 0:
		transition_to("idle")
