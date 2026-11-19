extends Node

signal enemy_staggered(enemy: Node)
signal parry_success(player: Node)
signal weakpoint_hit(enemy: Node, damage: float)
signal finisher_performed(player: Node, enemy: Node)
signal taunt_activated(player: Node)
signal dash_performed(player: Node)
signal seed_planted(position: Vector2)
signal plant_grown(position: Vector2)
signal boss_phase_changed(phase: int)
signal combo_increased(count: int)
signal portal_activated()

func emit_enemy_staggered(enemy: Node) -> void:
	enemy_staggered.emit(enemy)

func emit_parry_success(player: Node) -> void:
	parry_success.emit(player)

func emit_weakpoint_hit(enemy: Node, damage: float) -> void:
	weakpoint_hit.emit(enemy, damage)

func emit_finisher_performed(player: Node, enemy: Node) -> void:
	finisher_performed.emit(player, enemy)

func emit_taunt_activated(player: Node) -> void:
	taunt_activated.emit(player)

func emit_dash_performed(player: Node) -> void:
	dash_performed.emit(player)
