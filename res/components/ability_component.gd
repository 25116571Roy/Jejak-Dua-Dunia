extends AbilityComponent

var current_cooldown: float = 0.0
var last_activated_time: float = 0.0
var can_activate: bool = true

var taunt_radius: float = 260.0
var taunt_duration: float = 4.0
var cooldown_duration: float = 6.0

@onready var debug_visual = $DebugVisual

func _ready():
	super._ready()
	setup_ability("Taunt", 0, taunt_duration, cooldown_duration)
	if debug_visual:
		debug_visual.visible = false

func activate():
	if can_activate and _is_cooldown_expired():
		last_activated_time = Time.get_ticks_msec() / 1000.0
		current_cooldown = cooldown_duration
		can_activate = false
		emit_signal("ability_activated", "taunt")
		apply_vaunt_visuals()
		return true
	return false

func apply_vaunt_visuals():
	self.god_mode = true
	self.dash_velocity_invincible = true
	emit_signal("visual_feedback", "taunt_active", taunt_radius)

func restore_normal_state():
	emit_signal("visual_feedback", "taunt_deactivated")

func _handle_cooldown(delta):
	super._handle_cooldown(delta)
	if debug_visual and current_cooldown > 0:
		var remaining = min(current_cooldown / cooldown_duration, 1.0)
		debug_visual.scale.x = 1.0 + remaining
		debug_visual.scale.y = 1.0 + remaining
		debug_visual.modulate = Color(1.0, 1.0, 0.0, remaining)
	else:
		if debug_visual:
			debug_visual.scale.x = 1.0
			debug_visual.scale.y = 1.0
			debug_visual.modulate = Color(1.0, 1.0, 0.0, 1.0)