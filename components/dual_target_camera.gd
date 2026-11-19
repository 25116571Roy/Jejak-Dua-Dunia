extends Camera2D

@export var player1: Node2D
@export var player2: Node2D
@export var zoom_min: float = 0.62
@export var zoom_max: float = 1.0
@export var zoom_speed: float = 5.0
@export var max_distance: float = 800.0

var target_position: Vector2 = Vector2.ZERO
var target_zoom: float = 1.0

func _ready() -> void:
	_find_players()

func _find_players() -> void:
	if not player1:
		player1 = get_tree().get_first_node_in_group("player1")
	if not player2:
		player2 = get_tree().get_first_node_in_group("player2")

func _process(delta: float) -> void:
	if not player1 or not player2:
		_find_players()
		return
	
	_update_camera_position()
	_update_camera_zoom(delta)

func _update_camera_position() -> void:
	var midpoint := (player1.global_position + player2.global_position) / 2.0
	target_position = midpoint
	global_position = global_position.lerp(target_position, 0.1)

func _update_camera_zoom(delta: float) -> void:
	var distance := player1.global_position.distance_to(player2.global_position)
	var zoom_factor := clamp(1.0 - (distance / max_distance), zoom_min, zoom_max)
	
	target_zoom = zoom_factor
	zoom = zoom.lerp(Vector2.ONE * target_zoom, zoom_speed * delta)
