class_name Utils
extends Node

static func format_time(seconds: float) -> String:
	var minutes := int(seconds) / 60
	var secs := int(seconds) % 60
	var millis := int((seconds - int(seconds)) * 100)
	return "%02d:%02d.%02d" % [minutes, secs, millis]

static func lerp_color(from: Color, to: Color, weight: float) -> Color:
	return from.lerp(to, weight)

static func get_direction_to(from: Vector2, to: Vector2) -> Vector2:
	return (to - from).normalized()

static func get_distance_to(from: Vector2, to: Vector2) -> float:
	return from.distance_to(to)

static func is_in_range(from: Vector2, to: Vector2, range: float) -> bool:
	return get_distance_to(from, to) <= range

static func clamp_magnitude(vector: Vector2, max_magnitude: float) -> Vector2:
	if vector.length() > max_magnitude:
		return vector.normalized() * max_magnitude
	return vector

static func approach(current: float, target: float, delta: float) -> float:
	if current < target:
		return min(current + delta, target)
	else:
		return max(current - delta, target)

static func get_random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle := randf() * TAU
	var r := sqrt(randf()) * radius
	return center + Vector2(cos(angle), sin(angle)) * r

static func get_random_point_in_rect(rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + randf() * rect.size.x,
		rect.position.y + randf() * rect.size.y
	)

static func wrap_angle(angle: float) -> float:
	return fmod(angle + PI, TAU) - PI

static func smooth_damp(current: float, target: float, current_velocity: float, smooth_time: float, delta: float) -> Array:
	var omega := 2.0 / smooth_time
	var x := omega * delta
	var exp := 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	var change := current - target
	var temp := (current_velocity + omega * change) * delta
	var new_velocity := (current_velocity - omega * temp) * exp
	var new_value := target + (change + temp) * exp
	return [new_value, new_velocity]

static func play_sound_at_position(sound: AudioStream, position: Vector2, volume_db: float = 0.0) -> void:
	var player := AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = volume_db
	player.position = position
	player.finished.connect(player.queue_free)
	
	var scene_tree := Engine.get_main_loop() as SceneTree
	if scene_tree:
		scene_tree.current_scene.add_child(player)
		player.play()
