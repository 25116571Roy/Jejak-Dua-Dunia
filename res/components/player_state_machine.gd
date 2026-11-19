extends StateMachine

var player_id: int = 1
var is_grounded: bool = true
var facing_direction: float = 1.0
var can_dash: bool = false
var dash_ready: bool = true
var can_taunt: bool = true
var can_parry: bool = true
var can_finisher: bool = true
var can_weakpoint: bool = true

signal state_changed(new_state_name: String, previous_state_name: String)

func _ready():
	# Get player ID from parent node name or pass from outside
	super._ready()

func setup_player_specific():
	add_states(["idle", "running", "jump", "fall", "air_jump", "attack", "parry", "dash", "taunt", "finisher", "hurt", "down"])
	set_initial_state("idle")
	_connect_signals()

func _connect_signals():
	for state in get_children():
		if state is CharacterState:
			state.connect("state_input_requested", Callable(self, "_on_state_input_requested"))

func _on_state_input_requested(new_state_name: String):
	transition_to(new_state_name)
	state_changed.emit(new_state_name, current_state.name)

func _physics_process(delta):
	if not is_active:
		return

	var character = get_parent()
	if not character:
		return

	is_grounded = character.is_on_floor()

	if current_state.name == "idle":
		_transition_if_idle()

	elif current_state.name == "running":
		_transition_if_running()

	elif current_state.name == "jump":
		current_state.process_jump()

	elif current_state.name == "fall":
		current_state.process_fall()

	elif current_state.name == "hurt":
		current_state.process_hurt()

	current_state.update(delta)

func _transition_if_idle():
	if not is_idle():
		return

	var character = get_parent()
	if not character:
		return

	if can_dash and character.is_dash_ready():
		transition_to("dash")

func _transition_if_running():
	if not is_running():
		return

	var character = get_parent()
	if not character:
		return

	if not character.is_on_floor() and not character.has_double_jump():
		transition_to("air_jump")

func is_idle() -> bool:
	return current_state.name == "idle"

func is_running() -> bool:
	return current_state.name == "running"

func transition_to(state_name: String):
	if state_name not in get_children():
		push_error("State not found in state machine: ", state_name)
		return

	if current_state:
		current_state.exit()
	current_state = get_child(get_children().find(state_name))
	if current_state:
		current_state.enter()
	state_changed.emit(state_name, previous_state_name)