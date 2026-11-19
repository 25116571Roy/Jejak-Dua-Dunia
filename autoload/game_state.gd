extends Node

signal checkpoint_reached(checkpoint_id: String)
signal player_down(player_id: int)
signal player_revived(player_id: int)
signal level_complete(level_id: String)

var current_level: String = ""
var current_checkpoint: String = ""
var player1_hp: float = 100.0
var player2_hp: float = 100.0
var player1_down: bool = false
var player2_down: bool = false

var session_data: Dictionary = {
	"start_time": 0,
	"deaths": 0,
	"level_times": {},
	"combo_count": 0
}

func _ready() -> void:
	session_data.start_time = Time.get_ticks_msec()

func set_checkpoint(checkpoint_id: String) -> void:
	current_checkpoint = checkpoint_id
	checkpoint_reached.emit(checkpoint_id)

func save_checkpoint() -> Dictionary:
	return {
		"level": current_level,
		"checkpoint": current_checkpoint,
		"p1_hp": player1_hp,
		"p2_hp": player2_hp
	}

func load_checkpoint(data: Dictionary) -> void:
	current_level = data.get("level", "")
	current_checkpoint = data.get("checkpoint", "")
	player1_hp = data.get("p1_hp", 100.0)
	player2_hp = data.get("p2_hp", 100.0)

func set_player_down(player_id: int, is_down: bool) -> void:
	if player_id == 1:
		player1_down = is_down
	else:
		player2_down = is_down
	
	if is_down:
		player_down.emit(player_id)
		session_data.deaths += 1
	else:
		player_revived.emit(player_id)

func both_players_down() -> bool:
	return player1_down and player2_down

func reset_level() -> void:
	player1_hp = 100.0
	player2_hp = 100.0
	player1_down = false
	player2_down = false

func complete_level(level_id: String, time_taken: float) -> void:
	session_data.level_times[level_id] = time_taken
	level_complete.emit(level_id)
