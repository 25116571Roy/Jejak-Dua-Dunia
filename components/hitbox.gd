extends Area2D

signal hit_landed(target: Node)

@export var damage: float = 10.0
@export var knockback_force: float = 200.0
@export var stagger_value: float = 10.0
@export var hitbox_type: String = "player"

var owner_node: Node = null
var is_active: bool = true

func _ready() -> void:
	owner_node = owner
	area_entered.connect(_on_area_entered)

func set_active(active: bool) -> void:
	is_active = active
	monitoring = active

func _on_area_entered(area: Area2D) -> void:
	if not is_active:
		return
	
	if not area.is_in_group("hurtbox"):
		return
	
	var hurtbox := area as Node
	if hurtbox.has_method("receive_hit"):
		var target := hurtbox.owner if hurtbox.owner else hurtbox.get_parent()
		
		hurtbox.receive_hit(
			damage,
			global_position.direction_to(hurtbox.global_position),
			knockback_force,
			stagger_value
		)
		
		hit_landed.emit(target)
