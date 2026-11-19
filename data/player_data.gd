class_name PlayerData
extends Resource

@export var character_name: String = "Raka"
@export var max_health: float = 100.0
@export var movement_speed: float = 230.0
@export var jump_impulse: float = 640.0
@export var gravity: float = 980.0
@export var attack_damage: float = 20.0
@export var attack_cooldown: float = 0.5
@export var invincibility_duration: float = 1.0

@export_group("Raka Specific")
@export var parry_window: float = 0.25
@export var parry_stagger_bonus: float = 30.0
@export var taunt_radius: float = 260.0
@export var taunt_duration: float = 4.0
@export var taunt_cooldown: float = 6.0
@export var finisher_damage_multiplier: float = 3.5

@export_group("Nisa Specific")
@export var dash_speed: float = 760.0
@export var dash_duration: float = 0.16
@export var dash_cooldown: float = 0.8
@export var weakpoint_damage_multiplier: float = 2.5
@export var air_control_strength: float = 1.5
