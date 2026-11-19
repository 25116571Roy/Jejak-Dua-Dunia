extends Node

signal player_p1_spawned(actor_scene: PackedScene)
signal player_p2_spawned(actor_scene: PackedScene)

var current_level: String = ""
var split_screen_enabled: bool = false

var p1_health: float = 100.0
var p2_health: float = 100.0
var p1_is_dead: bool = false
var p2_is_dead: bool = false

func reset_game():
	p1_health = 100.0
	p2_health = 100.0
	p1_is_dead = false
	p2_is_dead = false
	current_level = ""

func set_level(level: String):
	current_level = level

func handle_player_down(player_id: int):
	match player_id:
		1:
			p1_is_dead = true
			emit_signal("player_1_down", p1_health)
		2:
			p2_is_dead = true
			emit_signal("player_2_down", p2_health)

func handle_player_revive(player_id: int, health: float):
	match player_id:
		1:
			p1_is_dead = false
			p1_health = health
		2:
			p2_is_dead = false
			p2_health = health

func get_player_health(player_id: int) -> float:
	match player_id:
		1:
			return p1_health
		2:
			return p2_health
	return 0.0

func heal_player(player_id: int, amount: float):
	match player_id:
		1:
			p1_health = min(p1_health + amount, 100.0)
		2:
			p2_health = min(p2_health + amount, 100.0)

func is_both_players_alive() -> bool:
	return !p1_is_dead and !p2_is_dead

var stage: Variant
func set_stage(stage_value: Variant):
	stage = stage_value

func get_stage() -> Variant:
	return stage

var waves_completed: int = 0
var stage_1_waves: int = 3
var stage_2_boss_completed: bool = false
var stage_3_completed: bool = false

func reset_stage_progress():
	waves_completed = 0
	stage_2_boss_completed = false
	stage_3_completed = false