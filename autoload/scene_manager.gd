extends Node

var overlay_fade: ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#setup fade overlay
	overlay_fade = ColorRect.new()
	overlay_fade.color = Color.BLACK
	overlay_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_fade.z_index = 100
	overlay_fade.modulate.a = 0.0
	add_child(overlay_fade)

func pindah_scene(path: String) -> void:
	await _fade_out()
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await _fade_in()

func ke_menu_utama() -> void:
	pindah_scene("res://ui/main_menu.tscn")

func ke_level(nomor: int) -> void:
	pindah_scene("res://levels/babak%d.tscn" % nomor)

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(overlay_fade, "modulate:a", 1.0, 0.3)
	await tween.finished

func _fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(overlay_fade, "modulate:a", 0.0, 0.3)
	await tween.finished
