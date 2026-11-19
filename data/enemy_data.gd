class_name EnemyData
extends Resource

@export var enemy_name: String = "Enemy"
@export var max_health: float = 60.0
@export var movement_speed: float = 150.0
@export var attack_damage: float = 10.0
@export var attack_range: float = 100.0
@export var stagger_threshold: float = 100.0
@export var stagger_duration: float = 3.5
@export var knockback_force: float = 200.0

@export_group("Behavior")
@export var aggro_range: float = 300.0
@export var attack_cooldown: float = 2.0
@export var wind_up_time: float = 0.5
@export var recovery_time: float = 0.5

@export_group("Loot")
@export var xp_reward: int = 10
@export var score_reward: int = 50
