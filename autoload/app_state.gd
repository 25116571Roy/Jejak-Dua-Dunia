extends Node

signal state_changed(new_state: String)

enum AppGameState {
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

var current_state: AppGameState = AppGameState.MAIN_MENU
var previous_state: AppGameState = AppGameState.MAIN_MENU

func change_state(new_state: AppGameState) -> void:
	previous_state = current_state
	current_state = new_state
	state_changed.emit(AppGameState.keys()[new_state])

func is_in_level() -> bool:
	return current_state in [AppGameState.BABAK_1, AppGameState.BABAK_2, AppGameState.BABAK_3]

func is_paused() -> bool:
	return current_state == AppGameState.PAUSE

func get_state_name(state: AppGameState) -> String:
	return AppGameState.keys()[state]
