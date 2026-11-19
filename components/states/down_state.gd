class_name DownState
extends State

var救援_timer: float = 0.0
var救援_required_time: float = 2.0

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("down")
	
	if actor.has_method("go_down"):
		actor.go_down()

func physics_update(delta: float) -> void:
	if actor.has_method("can_be_saved") and actor.can_be_saved():
		_check_for_救援(delta)

func _check_for_救援(delta: float) -> void:
	var nearby_players := _get_nearby_players()
	
	if nearby_players.size() > 0:
		救援_timer += delta
		if 救援_timer >= 救援_required_time:
			_救援_player()
	else:
		救援_timer = 0.0

func _get_nearby_players() -> Array:
	var nearby: Array = []
	var救援_range: float = 100.0
	
	for player in get_tree().get_nodes_in_group("player"):
		if player != actor:
			var distance := actor.global_position.distance_to(player.global_position)
			if distance <= 救援_range:
				nearby.append(player)
	
	return nearby

func _救援_player() -> void:
	if actor.has_method("be_saved"):
		actor.be_saved()
	transition_to("idle")
