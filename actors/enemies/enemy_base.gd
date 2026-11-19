class_name EnemyBase
extends CharacterBody2D

signal death
signal stagger_started
signal stagger_ended

@export var enemy_data: EnemyData
@export var player1: Node2D
@export var player2: Node2D

var health: Health
var stagger: Stagger
var state_machine: StateMachine
var is_dead: bool = false
var target_player: Node2D = null
var last_attack_time: float = 0.0
var facing_direction: float = 1.0

func _ready() -> void:
	if not enemy_data:
		enemy_data = EnemyData.new()
	
	_setup_components()
	_find_players()

func _setup_components() -> void:
	health = $Health
	if not health:
		health = Health.new()
		health.max_health = enemy_data.max_health
		add_child(health)
	
	stagger = $Stagger
	if not stagger:
		stagger = Stagger.new()
		stagger.stagger_threshold = enemy_data.stagger_threshold
		add_child(stagger)
	
	state_machine = $StateMachine
	if not state_machine:
		state_machine = StateMachine.new()
		add_child(state_machine)
	
	health.health_depleted.connect(_on_death)
	stagger.stagger_full.connect(_on_stagger_start)
	stagger.stagger_recovered.connect(_on_stagger_end)

func _find_players() -> void:
	if not player1:
		player1 = get_tree().get_first_node_in_group("player1")
	if not player2:
		player2 = get_tree().get_first_node_in_group("player2")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += enemy_data.movement_speed * delta
	
	move_and_slide()

func select_target() -> Node2D:
	var closest: Node2D = null
	var closest_distance: float = INF
	
	for player in [player1, player2]:
		if not player:
			continue
		
		var distance := global_position.distance_to(player.global_position)
		if distance < closest_distance:
			closest = player
			closest_distance = distance
	
	target_player = closest
	return closest

func take_damage(damage: float, direction: Vector2, knockback: float, stagger_amount: float) -> void:
	if is_dead:
		return
	
	health.take_damage(damage)
	
	if knockback > 0:
		velocity += direction * knockback
	
	if stagger_amount > 0:
		stagger.add_stagger(stagger_amount)

func _on_death() -> void:
	is_dead = true
	death.emit()
	EventBus.emit_enemy_staggered(self)

func _on_stagger_start() -> void:
	stagger_started.emit()
	if state_machine:
		state_machine.change_state("stagger")

func _on_stagger_end() -> void:
	stagger_ended.emit()
	if state_machine:
		state_machine.change_state("idle")

func is_in_range(distance: float) -> bool:
	return global_position.distance_to(target_player.global_position) <= distance if target_player else false

func get_direction_to_target() -> Vector2:
	if not target_player:
		return Vector2.ZERO
	
	return global_position.direction_to(target_player.global_position)
