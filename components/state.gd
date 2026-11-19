class_name State
extends Node

signal finished(next_state: String)

var state_machine: StateMachine
var actor: Node

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func transition_to(state_name: String) -> void:
	finished.emit(state_name)
