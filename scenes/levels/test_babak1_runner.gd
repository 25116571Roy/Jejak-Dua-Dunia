extends Node2D

var passed_checks: int = 0
var total_checks: int = 0

func assert_check(condition: bool, message: String) -> void:
	total_checks += 1
	if condition:
		passed_checks += 1
		print("  [PASS] ", message)
	else:
		printerr("  [FAIL] ", message)

func _ready() -> void:
	print("\n=== STARTING BABAK 1 HEADLESS TEST SUITE ===")
	
	# 1. Test Load Wave Data
	print("\n1. Testing Wave Data Resource...")
	var wave_res: WaveData = load("res://data/wave_data/babak1_waves.tres")
	assert_check(wave_res != null, "babak1_waves.tres exists and loads as WaveData")
	assert_check(wave_res.gelombang.size() == 3, "Wave count is 3")
	assert_check(wave_res.waves.size() == 3, "Alias 'waves' works and returns 3")
	
	# 2. Test SeedPoint Scene & Mechanics
	print("\n2. Testing SeedPoint Scene & Mechanics...")
	var seed_scene: PackedScene = load("res://levels/babak1/seed_point.tscn")
	assert_check(seed_scene != null, "seed_point.tscn exists and loads")
	var sp: Area2D = seed_scene.instantiate()
	add_child(sp)
	sp.global_position = Vector2(100, 100)
	assert_check(sp.is_in_group("seed_points"), "SeedPoint is in group 'seed_points'")
	assert_check(sp.collision_layer == 128, "SeedPoint collision_layer is 128 (Layer 8: Interaktif)")
	
	# Test planting far away (should not plant)
	EventBus.seed_planted.emit(Vector2(500, 500))
	assert_check(not sp.get("is_planted"), "Seed does not plant when distant")
	
	# Test planting near
	EventBus.seed_planted.emit(Vector2(110, 105))
	assert_check(sp.get("is_planted"), "Seed plants when close")
	
	# Quick-finish growth for test
	var seed_grown_fired := [false]
	var cb_grown := func(pos: Vector2): seed_grown_fired[0] = true
	EventBus.seed_grown.connect(cb_grown)
	sp._on_grown()
	assert_check(sp.get("is_grown"), "Seed grows after timer")
	assert_check(seed_grown_fired[0], "EventBus.seed_grown signal was emitted")
	EventBus.seed_grown.disconnect(cb_grown)
	sp.queue_free()

	# 3. Test Portal Logic
	print("\n3. Testing Portal Co-op Mechanics...")
	var portal_scene: PackedScene = load("res://levels/babak1/portal.tscn")
	assert_check(portal_scene != null, "portal.tscn exists and loads")
	var portal: Area2D = portal_scene.instantiate()
	add_child(portal)
	assert_check(portal.is_in_group("portals"), "Portal is in group 'portals'")
	assert_check(not portal.get("is_active"), "Portal is initially inactive")
	
	# Test player entering when inactive (should do nothing)
	var dummy_p1 := CharacterBody2D.new()
	dummy_p1.add_to_group("players")
	dummy_p1.set("player_id", 1)
	
	var dummy_p2 := CharacterBody2D.new()
	dummy_p2.add_to_group("players")
	dummy_p2.set("player_id", 2)
	
	var level_complete_fired := [false]
	var cb_complete := func(b: int): level_complete_fired[0] = true
	EventBus.level_complete.connect(cb_complete)
	
	portal._on_body_entered(dummy_p1)
	portal._on_body_entered(dummy_p2)
	assert_check(not level_complete_fired[0], "Portal does not trigger level_complete while inactive")
	
	# Activate portal
	portal.activate()
	assert_check(portal.get("is_active"), "Portal is now active")
	
	# Only player 1 enters
	portal.players_inside.clear()
	portal._on_body_entered(dummy_p1)
	assert_check(portal.get("players_inside").size() == 1, "Only 1 player registered in portal")
	assert_check(not level_complete_fired[0], "Level complete not fired when only 1 player inside")
	
	# Player 2 enters
	portal._on_body_entered(dummy_p2)
	assert_check(level_complete_fired[0], "Level complete fired when BOTH players entered active portal")
	EventBus.level_complete.disconnect(cb_complete)
	
	dummy_p1.queue_free()
	dummy_p2.queue_free()
	portal.queue_free()

	# 4. Test Arena Assembly
	print("\n4. Testing Babak 1 Arena Scene...")
	var arena_scene: PackedScene = load("res://levels/babak1/babak1_arena.tscn")
	assert_check(arena_scene != null, "babak1_arena.tscn exists and loads")
	var arena: Node = arena_scene.instantiate()
	add_child(arena)
	
	assert_check(arena.get_node_or_null("Terrain") != null, "Arena has TileMapLayer 'Terrain'")
	assert_check(arena.get_node_or_null("WaveManager") != null, "Arena has WaveManager")
	assert_check(arena.get_node_or_null("SeedPoints") != null, "Arena has SeedPoints container")
	assert_check(arena.get_node_or_null("SeedPoints").get_child_count() == 3, "Arena has 3 SeedPoints")
	assert_check(arena.get_node_or_null("Portal") != null, "Arena has Portal")
	assert_check(arena.get_node_or_null("Spawners") != null, "Arena has Spawners container")
	assert_check(arena.get_node_or_null("Player1") != null, "Arena has Player1 (Raka)")
	assert_check(arena.get_node_or_null("Player2") != null, "Arena has Player2 (Nisa)")
	assert_check(arena.get_node_or_null("TutorialManager") != null, "Arena has TutorialManager")

	# Test WaveManager auto-discovery
	var wave_mgr: Node = arena.get_node_or_null("WaveManager")
	assert_check(wave_mgr.get("spawners").size() == 3, "WaveManager auto-discovered 3 spawners")

	arena.queue_free()

	# 5. Test Babak 1 Root Scene (with Split Screen)
	print("\n5. Testing Babak 1 Root Split-Screen Scene...")
	var babak1_scene: PackedScene = load("res://levels/babak1.tscn")
	assert_check(babak1_scene != null, "levels/babak1.tscn exists and loads")
	var babak1: Node = babak1_scene.instantiate()
	add_child(babak1)
	assert_check(babak1.get("scene_level") != null, "babak1.tscn has scene_level assigned")
	babak1.queue_free()

	print("\n=== TEST RESULTS: %d/%d PASSED ===" % [passed_checks, total_checks])
	if passed_checks == total_checks:
		print("ALL BABAK 1 TESTS PASSED PERFECTLY!\n")
	else:
		printerr("SOME TESTS FAILED!\n")

	get_tree().quit()
