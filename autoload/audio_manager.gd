extends Node

const MAX_SFX_PLAYERS := 16

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")
var voice_bus := AudioServer.get_bus_index("Voice")
var ui_bus := AudioServer.get_bus_index("UI")

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var current_sfx_index: int = 0

func _ready() -> void:
	_setup_buses()
	_setup_players()

func _setup_buses() -> void:
	if music_bus == -1:
		music_bus = AudioServer.get_bus_count()
		AudioServer.add_bus(music_bus)
		AudioServer.set_bus_name(music_bus, "Music")
	
	if sfx_bus == -1:
		sfx_bus = AudioServer.get_bus_count()
		AudioServer.add_bus(sfx_bus)
		AudioServer.set_bus_name(sfx_bus, "SFX")
	
	if voice_bus == -1:
		voice_bus = AudioServer.get_bus_count()
		AudioServer.add_bus(voice_bus)
		AudioServer.set_bus_name(voice_bus, "Voice")
	
	if ui_bus == -1:
		ui_bus = AudioServer.get_bus_count()
		AudioServer.add_bus(ui_bus)
		AudioServer.set_bus_name(ui_bus, "UI")

func _setup_players() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	for i in MAX_SFX_PLAYERS:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)

func play_music(stream: AudioStream, fade_in: float = 0.0) -> void:
	if music_player.stream == stream and music_player.playing:
		return
	
	music_player.stream = stream
	music_player.play()

func stop_music(fade_out: float = 0.0) -> void:
	music_player.stop()

func play_sfx(stream: AudioStream, pitch_variance: float = 0.0) -> void:
	var player := sfx_players[current_sfx_index]
	current_sfx_index = (current_sfx_index + 1) % MAX_SFX_PLAYERS
	
	player.stream = stream
	player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
	player.play()

func set_music_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, volume_db)

func set_sfx_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, volume_db)

func set_voice_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(voice_bus, volume_db)

func set_ui_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(ui_bus, volume_db)
