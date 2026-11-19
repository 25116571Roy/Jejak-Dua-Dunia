extends Node2D

@export var next_level: String = ""
@export var portal_enabled: bool = false

var players_in_portal: Array[Node] = []

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func enable() -> void:
	portal_enabled = true
	$AnimationPlayer.play("activate") if has_node("AnimationPlayer") else null

func disable() -> void:
	portal_enabled = false

func _on_body_entered(body: Node2D) -> void:
	if not portal_enabled:
		return
	
	if body.is_in_group("player"):
		if not players_in_portal.has(body):
			players_in_portal.append(body)
		
		_check_both_players()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		players_in_portal.erase(body)

func _check_both_players() -> void:
	if players_in_portal.size() >= 2:
		_activate_portal()

func _activate_portal() -> void:
	EventBus.portal_activated.emit()
	
	if next_level != "":
		SceneManager.goto_level(next_level)
	else:
		SceneManager.goto_main_menu()
