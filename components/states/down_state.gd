class_name DownState
extends State

var rescue_timer: float = 0.0
var rescue_required_time: float = 2.0

func enter() -> void:
	if actor.has_method("play_animation"):
		actor.play_animation("down")
	
	if actor.has_method("go_down"):
		actor.go_down()

func physics_update(delta: float) -> void:
	if actor.has_method("can_be_saved") and actor.can_be_saved():
		_check_for_rescue(delta)

func _check_for_rescue(delta: float) -> void:
	var nearby_players := _get_nearby_players()
	
	if nearby_players.size() > 0:
		rescue_timer += delta
		if rescue_timer >= rescue_required_time:
			_rescue_player()
	else:
		rescue_timer = 0.0

func _get_nearby_players() -> Array:
	var nearby: Array = []
	var rescue_range: float = 100.0
	
	for player in get_tree().get_nodes_in_group("player"):
		if player != actor:
			var distance: float = actor.global_position.distance_to(player.global_position)
			if distance <= rescue_range:
				nearby.append(player)
	
	return nearby

func _rescue_player() -> void:
	if actor.has_method("be_saved"):
		actor.be_saved()
	transition_to("idle")
