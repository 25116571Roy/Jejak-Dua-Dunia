extends Node2D

@export var portal_scene: PackedScene
@export var checkpoint_id: String = "checkpoint_1"

var players_in_area: Array[Node] = []
var is_active: bool = false

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	
	GameState.checkpoint_reached.connect(_on_checkpoint_reached)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not players_in_area.has(body):
			players_in_area.append(body)
		
		_check_both_players()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		players_in_area.erase(body)

func _check_both_players() -> void:
	if players_in_area.size() >= 2:
		activate_checkpoint()

func activate_checkpoint() -> void:
	if is_active:
		return
	
	is_active = true
	GameState.set_checkpoint(checkpoint_id)
	
	$AnimationPlayer.play("activate") if has_node("AnimationPlayer") else null

func _on_checkpoint_reached(id: String) -> void:
	if id == checkpoint_id:
		pass
