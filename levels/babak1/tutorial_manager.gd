class_name TutorialManager
extends Node

var _shown: Dictionary = {}

func _ready() -> void:
	EventBus.wave_started.connect(_on_wave_started)

func _on_wave_started(babak: int, wave_no: int) -> void:
	if babak != 1:
		return
		
	if wave_no == 1:
		var timer := get_tree().create_timer(3.0)
		timer.timeout.connect(func():
			if not _shown.get("taunt_prompt", false):
				_shown["taunt_prompt"] = true
				EventBus.show_prompt.emit("Tekan G untuk Taunt (menarik perhatian musuh)!", 1)
		)
	elif wave_no == 2:
		var timer := get_tree().create_timer(1.0)
		timer.timeout.connect(func():
			if not _shown.get("dash_prompt", false):
				_shown["dash_prompt"] = true
				EventBus.show_prompt.emit("Tekan '.' untuk Dash menembus bahaya!", 2)
		)

func _process(_delta: float) -> void:
	if _shown.get("parry_prompt", false) and _shown.get("weakpoint_prompt", false):
		return
		
	var enemies := get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
			
		var enemy_state: String = enemy.get("state") if enemy.get("state") != null else ""
		if enemy_state == "windup":
			# Cek jenis musuh
			var script_name: String = ""
			if enemy.get_script():
				script_name = enemy.get_script().resource_path.to_lower()
				
			if "swordsman" in script_name or "pedang" in enemy.name.to_lower():
				if not _shown.get("parry_prompt", false):
					_shown["parry_prompt"] = true
					EventBus.show_prompt.emit("Tekan H saat tanda seru musuh muncul untuk Parry!", 1)
			elif "archer" in script_name or "pemanah" in enemy.name.to_lower():
				if not _shown.get("weakpoint_prompt", false):
					_shown["weakpoint_prompt"] = true
					EventBus.show_prompt.emit("Serang kepala pemanah saat menarik busur!", 2)
