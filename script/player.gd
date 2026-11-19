extends CharacterBody2D

@export var kecepatan: float = 200.0
@export var kekuatan_lompat: float = -400.0
@export var batas_level: Rect2 = Rect2(0,0,1280,720)
@export var player_id: int = 1
@export var sprite_texture: Texture2D


var gravitasi: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var posisi_spawn : Vector2

var gerak_kiri: String
var gerak_kanan: String
var gerak_loncat: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	posisi_spawn = global_position
	gerak_kiri= "p%d_left" % player_id
	gerak_kanan = "p%d_right" % player_id
	gerak_loncat = "p%d_jump" % player_id
	if sprite_texture:
		$Sprite2D.texture = sprite_texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#gravitasi
	if not is_on_floor():
		velocity.y += gravitasi * delta
	
	#cek dinggo nyolot
	if Input.is_action_just_pressed(gerak_loncat) and is_on_floor():
		velocity.y = kekuatan_lompat
		
	
	#obah horizontal
	var arah := Input.get_axis(gerak_kiri,gerak_kanan)
	velocity.x = arah * kecepatan
	print("kanan kiri =", velocity.x)
	
	move_and_slide()
	
	if not batas_level.has_point(global_position):
		respawn()
	print("posisi global =", global_position)
	
	pass


func respawn() -> void:
	#set posisi respawn koyok turu neng minecraft
	global_position = posisi_spawn
	velocity = Vector2.ZERO
