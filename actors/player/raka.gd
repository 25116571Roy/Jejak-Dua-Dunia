class_name RakaCharacter
extends PlayerBase

@export var parry_data: PlayerData

var parry_cooldown: float = 0.0
var taunt_cooldown: float = 0.0
var can_parry: bool = true

func _ready() -> void:
	player_id = 1
	if not player_data:
		var data := PlayerData.new()
		data.character_name = "Raka"
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
	
	if InputRouter.is_action_just_pressed(player_id, "jump") and is_on_floor():
		velocity.y = -player_data.jump_impulse
	
	if InputRouter.is_action_just_pressed(player_id, "attack"):
		_perform_attack()
	
	if InputRouter.is_action_just_pressed(player_id, "parry") and can_parry:
		_perform_parry()
	
	if InputRouter.is_action_just_pressed(player_id, "taunt"):
		_perform_taunt()
	
	_update_cooldowns(delta)

func _perform_attack() -> void:
	EventBus.combo_increased.emit(1)
	ability_used.emit("attack")

func _perform_parry() -> void:
	can_parry = false
	EventBus.parry_success.emit(self)
	ability_used.emit("parry")

func _perform_taunt() -> void:
	if taunt_cooldown > 0:
		return
	
	EventBus.taunt_activated.emit(self)
	taunt_cooldown = player_data.taunt_cooldown
	ability_used.emit("taunt")

func _update_cooldowns(delta: float) -> void:
	if parry_cooldown > 0:
		parry_cooldown -= delta
	else:
		can_parry = true
	
	if taunt_cooldown > 0:
		taunt_cooldown -= delta
