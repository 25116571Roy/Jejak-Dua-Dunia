class_name SwordmanEnemy
extends EnemyBase

@export var attack_range_close: float = 50.0
@export var heavy_attack_chance: float = 0.3

var is_attacking: bool = false
var is_heavy_attack: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_dead:
		return
	
	select_target()
	
	if not target_player:
		return
	
	var distance := global_position.distance_to(target_player.global_position)
	
	if distance > enemy_data.attack_range:
		_move_towards_player()
	elif distance <= attack_range_close and not is_attacking:
		_try_attack()
	else:
		velocity.x = 0

func _move_towards_player() -> void:
	var direction := get_direction_to_target()
	velocity.x = direction.x * enemy_data.movement_speed
	facing_direction = sign(direction.x)

func _try_attack() -> void:
	last_attack_time += get_physics_process_delta_time()
	
	if last_attack_time >= enemy_data.attack_cooldown:
		is_attacking = true
		is_heavy_attack = randf() < heavy_attack_chance
		
		if state_machine:
			state_machine.change_state("attack")
		
		last_attack_time = 0.0

func perform_attack() -> void:
	if is_heavy_attack:
		health.take_damage(-10)
	
	is_attacking = false

func stop_attack() -> void:
	is_attacking = false
	if state_machine:
		state_machine.change_state("idle")
