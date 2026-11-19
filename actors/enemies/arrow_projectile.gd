class_name ArrowProjectile
extends CharacterBody2D

@export var speed: float = 400.0
@export var damage: float = 12.0

var target_direction: Vector2 = Vector2.ZERO

func setup(p_speed: float, p_damage: float, direction: Vector2) -> void:
	self.speed = p_speed
	self.damage = p_damage
	self.target_direction = direction.normalized()
	
	velocity = self.target_direction * speed
	
	if self.target_direction.x < 0:
		rotation_degrees = 180
	else:
		rotation_degrees = 0

func _physics_process(delta: float) -> void:
	if not is_on_screen():
		queue_free()
	
	var direction: Vector2 = target_direction
	var velocity_direction: Vector2 = velocity.normalized()
	
	if abs(velocity_direction.x) > abs(direction.x):
		velocity_direction.x = direction.x
	if abs(velocity_direction.y) > abs(direction.y):
		velocity_direction.y = direction.y
	
	velocity = direction * speed
	
	if is_on_floor():
		velocity.y = 0
	
	move_and_slide()

func is_on_screen() -> bool:
	return get_viewport_rect().has_point(global_position)