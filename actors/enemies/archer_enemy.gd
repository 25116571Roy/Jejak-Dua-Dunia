class_name ArcherEnemy
extends EnemyBase

const ARROW_PROJECTILE = preload("res://actors/enemies/arrow_projectile.tscn")

@export var draw_time: float = 1.0
@export var projectile_speed: float = 400.0
@export var projectile_damage: float = 12.0

var draw_timer: float = 0.0
var is_drawing: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_dead or is_on_floor():
		return
	
	select_target()
	
	if not target_player:
		return
	
	var distance := global_position.distance_to(target_player.global_position)
	
	if distance > enemy_data.attack_range:
		_move_towards_player()
	else:
		_try_shoot()

func _move_towards_player() -> void:
	var direction := get_direction_to_target()
	velocity.x = direction.x * enemy_data.movement_speed
	facing_direction = sign(direction.x)

func _try_shoot() -> void:
	last_attack_time += get_physics_process_delta_time()
	
	if last_attack_time >= enemy_data.attack_cooldown:
		if not is_drawing:
			is_drawing = true
			draw_timer = 0.0
		
		draw_timer += get_physics_process_delta_time()
		
		if draw_timer >= draw_time:
			_fire_arrow()
			is_drawing = false
			last_attack_time = 0.0

func _fire_arrow() -> void:
	if not target_player:
		return
	
	var arrow := ARROW_PROJECTILE.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	arrow.setup(projectile_speed, projectile_damage, get_direction_to_target())
