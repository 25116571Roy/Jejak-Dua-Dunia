extends Area2D

signal hit_received(hitbox: Area2D, damage: float)

func _ready() -> void:
	add_to_group("hurtboxes")
	area_entered.connect(_on_area_masuk)

func _on_area_masuk(area: Area2D) -> void:
	if not area.is_in_group("hitboxes") or not area.is_active:
		return

	var pemilik := get_parent()

	#damage
	var health := pemilik.get_node_or_null("Health")
	if health:
		health.take_damage(area.damage)

	#stagger (hanya musuh punya node Stagger)
	var stagger := pemilik.get_node_or_null("Stagger")
	if stagger:
		stagger.add_stagger(area.stagger_damage)

	#knockback
	if pemilik is CharacterBody2D and area.knockback_force > 0.0:
		var arah: Vector2 = (pemilik.global_position - area.get_parent().global_position).normalized()
		pemilik.velocity += arah * area.knockback_force

	hit_received.emit(area, area.damage)
	EventBus.hit_landed.emit(area.get_parent(), pemilik, area.damage)
