extends Node

@export var analytics_enabled: bool = true

var session_start_time: float = 0.0
var events: Array[Dictionary] = []

func _ready() -> void:
	session_start_time = Time.get_ticks_msec()

func log_event(event_name: String, data: Dictionary = {}) -> void:
	if not analytics_enabled:
		return
	
	var event := {
		"name": event_name,
		"timestamp": Time.get_ticks_msec() - session_start_time,
		"data": data
	}
	events.append(event)

func log_parry_success(player_name: String) -> void:
	log_event("parry_success", {"player": player_name})

func log_dash_performed(player_name: String) -> void:
	log_event("dash_performed", {"player": player_name})

func log_finisher_performed(player_name: String, enemy_name: String) -> void:
	log_event("finisher", {"player": player_name, "enemy": enemy_name})

func log_player_death(player_name: String, cause: String) -> void:
	log_event("player_death", {"player": player_name, "cause": cause})

func log_enemy_killed(enemy_name: String, time: float) -> void:
	log_event("enemy_killed", {"enemy": enemy_name, "time": time})

func log_level_complete(level_id: String, time: float, deaths: int) -> void:
	log_event("level_complete", {
		"level": level_id,
		"time": time,
		"deaths": deaths
	})

func export_to_csv(file_path: String) -> void:
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return
	
	file.store_line("event_name,timestamp,data")
	
	for event in events:
		var data_str := JSON.stringify(event.data)
		file.store_line("%s,%d,%s" % [event.name, event.timestamp, data_str])
	
	file.close()

func get_session_duration() -> float:
	return (Time.get_ticks_msec() - session_start_time) / 1000.0

func clear_events() -> void:
	events.clear()
