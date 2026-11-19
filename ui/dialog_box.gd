extends Control

@export var dialog_data: Array[Dictionary] = []

@onready var name_label := $Panel/NameLabel
@onready var text_label := $Panel/TextLabel
@onready var portrait := $Panel/Portrait

var current_dialog_index: int = 0
var is_typing: bool = false
var text_speed: float = 0.05

signal dialog_finished()

func _ready() -> void:
	hide()

func start_dialog(dialogs: Array[Dictionary]) -> void:
	dialog_data = dialogs
	current_dialog_index = 0
	show()
	_display_next_dialog()

func _display_next_dialog() -> void:
	if current_dialog_index >= dialog_data.size():
		_finish_dialog()
		return
	
	var dialog := dialog_data[current_dialog_index]
	name_label.text = dialog.get("name", "")
	
	if dialog.has("portrait"):
		portrait.texture = dialog.portrait
	
	_type_text(dialog.get("text", ""))

func _type_text(text: String) -> void:
	is_typing = true
	text_label.text = ""
	
	for i in text.length():
		text_label.text += text[i]
		await get_tree().create_timer(text_speed).timeout
	
	is_typing = false

func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			is_typing = false
			text_label.text = dialog_data[current_dialog_index].get("text", "")
		else:
			current_dialog_index += 1
			_display_next_dialog()

func _finish_dialog() -> void:
	hide()
	dialog_finished.emit()
