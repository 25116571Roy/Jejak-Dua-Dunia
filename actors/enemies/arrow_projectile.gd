class_name ArrowProjectile
extends Area2D

@export var speed: float = 400.0
@export var damage: float = 12.0

var target_direction: Vector2 = Vector2.ZERO

func setup(speed: float, damage: float, direction: Vector2) -> void:
	self.speed = speed
	self.damage = damage
	self.target_direction = direction.normalized()
	
	velocity = self.target_direction * speed
	
	if self.target_direction.x < 0:
		rotation_degrees = 180
	else:
		rotation_degrees = 0

func _physics_process(delta: float) -> void:
	if not is_on_screen():
		queue_free()
	
	var direction := target_direction
	var velocity_direction := velocity.normalized()
	
	if abs(velocity_direction.x) > abs(direction.x):
		velocity_direction.x = direction.x
	if abs(velocity_direction.y) > abs(direction.y):
		velocity_direction.y = direction.y
	
	velocity = direction * speed
	
	if is_on_floor():
		velocity.y = 0
	
	move_and_slide()