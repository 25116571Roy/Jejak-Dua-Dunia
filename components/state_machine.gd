class_name StateMachine
extends Node

signal state_changed(old_state: State, new_state: State)

@export var initial_state: State

var current_state: State
var previous_state: State
var states: Dictionary = {}

func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.actor = owner
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func change_state(state_name: String) -> void:
	var new_state := states.get(state_name.to_lower()) as State
	
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	
	current_state.enter()
	state_changed.emit(previous_state, current_state)

func get_state(state_name: String) -> State:
	return states.get(state_name.to_lower())

func is_in_state(state_name: String) -> bool:
	return current_state and current_state.name.to_lower() == state_name.to_lower()

func get_current_state_name() -> String:
	return current_state.name if current_state else ""
