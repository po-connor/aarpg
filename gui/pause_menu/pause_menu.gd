extends CanvasLayer

signal shown
signal hidden

@onready var save_button: Button = $Control/HBoxContainer/SaveButton
@onready var load_button: Button = $Control/HBoxContainer/LoadButton

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Control/AudioStreamPlayer2D

var is_paused: bool = false

func _ready() -> void:
	hide_pause_menu()
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func show_pause_menu() -> void:
	load_button.disabled = !SaveManager.save_file_exists()
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()

func hide_pause_menu() -> void:
	visible = false
	is_paused = false
	get_tree().paused = false
	hidden.emit()

func play_audio(audio: AudioStream) -> void:
	audio_stream_player_2d.stream = audio
	audio_stream_player_2d.play()
	
