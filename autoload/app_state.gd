extends Node

signal state_changed(new_state: String)

enum GameState {
	MAIN_MENU,
	MODE_SELECT,
	LOADING,
	BABAK_1,
	BABAK_2,
	BABAK_3,
	PAUSE,
	GAME_OVER,
	LEVEL_COMPLETE
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU

func change_state(new_state: GameState) -> void:
	previous_state = current_state
	current_state = new_state
	state_changed.emit(GameState.keys()[new_state])

func is_in_level() -> bool:
	return current_state in [GameState.BABAK_1, GameState.BABAK_2, GameState.BABAK_3]

func is_paused() -> bool:
	return current_state == GameState.PAUSE

func get_state_name(state: GameState) -> String:
	return GameState.keys()[state]
