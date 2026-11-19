extends CanvasLayer

@onready var player1_hp_bar := $MarginContainer/HBoxContainer/Player1Panel/HPBar
@onready var player2_hp_bar := $MarginContainer/HBoxContainer/Player2Panel/HPBar
@onready var player1_cooldown := $MarginContainer/HBoxContainer/Player1Panel/CooldownIndicator
@onready var player2_cooldown := $MarginContainer/HBoxContainer/Player2Panel/CooldownIndicator

func _ready() -> void:
	GameState.player_down.connect(_on_player_down)
	GameState.player_revived.connect(_on_player_revived)

func update_player1_hp(current: float, max_hp: float) -> void:
	if player1_hp_bar:
		player1_hp_bar.max_value = max_hp
		player1_hp_bar.value = current

func update_player2_hp(current: float, max_hp: float) -> void:
	if player2_hp_bar:
		player2_hp_bar.max_value = max_hp
		player2_hp_bar.value = current

func update_player1_cooldown(value: float) -> void:
	if player1_cooldown:
		player1_cooldown.value = value

func update_player2_cooldown(value: float) -> void:
	if player2_cooldown:
		player2_cooldown.value = value

func _on_player_down(player_id: int) -> void:
	if player_id == 1:
		$MarginContainer/HBoxContainer/Player1Panel.modulate = Color(1, 0.3, 0.3)
	else:
		$MarginContainer/HBoxContainer/Player2Panel.modulate = Color(1, 0.3, 0.3)

func _on_player_revived(player_id: int) -> void:
	if player_id == 1:
		$MarginContainer/HBoxContainer/Player1Panel.modulate = Color.WHITE
	else:
		$MarginContainer/HBoxContainer/Player2Panel.modulate = Color.WHITE
