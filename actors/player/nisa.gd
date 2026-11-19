class_name NisaCharacter
extends PlayerBase

@export var dash_data: PlayerData

var dash_cooldown: float = 0.0
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	player_id = 2
	if not player_data:
		var data := PlayerData.new()
		data.character_name = "Nisa"
		player_data = data
	super._ready()

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	super._physics_process(delta)

func _handle_input(delta: float) -> void:
	var move_input := InputRouter.get_axis(player_id, "move_left", "move_right")
	
	if move_input != 0:
		facing_direction = sign(move_input)
		velocity.x = move_input * player_data.movement_speed
	else:
		velocity.x = 0
	
	if InputRouter.is_action_just_pressed(player_id, "jump"):
		if is_on_floor():
			velocity.y = -player_data.jump_impulse
		else:
			velocity.y = -player_data.jump_impulse * 0.5
	
	if InputRouter.is_action_just_pressed(player_id, "attack"):
		_perform_attack()
	
	if InputRouter.is_action_just_pressed(player_id, "dash") and can_dash:
		_perform_dash()
	
	_update_cooldowns(delta)

func _perform_attack() -> void:
	EventBus.combo_increased.emit(1)
	ability_used.emit("attack")

func _perform_dash() -> void:
	can_dash = false
	is_dashing = true
	dash_direction = Vector2(facing_direction, 0).normalized()
	
	velocity = dash_direction * player_data.dash_speed
	
	EventBus.dash_performed.emit(self)
	ability_used.emit("dash")
	
	await get_tree().create_timer(player_data.dash_duration).timeout
	is_dashing = false

func _update_cooldowns(delta: float) -> void:
	if dash_cooldown > 0:
		dash_cooldown -= delta
	else:
		can_dash = true
