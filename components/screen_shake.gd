extends Node

const SCREEN_SHAKE_DECAY := 5.0

var trauma: float = 0.0
var trauma_power: int = 2
var max_offset: float = 100.0
var max_roll: float = 0.1

var camera: Camera2D
var noise: FastNoiseLite
var noise_y: int = 0

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 2.0

func _process(delta: float) -> void:
	if not camera:
		return
	
	if trauma > 0:
		trauma = max(trauma - SCREEN_SHAKE_DECAY * delta, 0)
		_apply_shake()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func _apply_shake() -> void:
	var amount := pow(trauma, trauma_power)
	noise_y += 1
	
	camera.offset.x = max_offset * amount * noise.get_noise_2d(noise.seed, noise_y)
	camera.offset.y = max_offset * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	camera.rotation = max_roll * amount * noise.get_noise_2d(noise.seed * 3, noise_y)

func set_camera(cam: Camera2D) -> void:
	camera = cam

func shake_light() -> void:
	add_trauma(0.3)

func shake_medium() -> void:
	add_trauma(0.5)

func shake_heavy() -> void:
	add_trauma(0.8)
