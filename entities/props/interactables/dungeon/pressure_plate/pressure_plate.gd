class_name PressurePlate extends Node2D

signal activated
signal deactivated

@onready var sprite: Sprite2D = $Sprite
@onready var area: Area2D = $Area
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var audio_activate: AudioStream = preload("uid://cdttxq0ck6vdk")
@onready var audio_deactivate: AudioStream = preload("uid://da1nerjhtmrbm")
@onready var data_handler: PersistentDataHandler = $DataHandler

var bodies_count: int = 0
var is_active: bool = false
var rect_offset: Rect2

func _ready() -> void:
	if data_handler:
		data_handler.data_loaded.connect(_set_state)
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	if sprite:
		rect_offset = sprite.region_rect
	_set_state()
	
func _on_body_entered(_body: Node2D) -> void:
	bodies_count += 1
	_check_is_activated()

func _on_body_exited(_body: Node2D) -> void:
	if LevelManager.is_transitioning:
		return
	bodies_count -= 1
	_check_is_activated()

func _activate() -> void:
	is_active = true
	data_handler.set_value("is_active", is_active)
	_update_texture()
	_play_audio(audio_activate)
	activated.emit()

func _deactivate() -> void:
	is_active = false
	data_handler.set_value("is_active", is_active)
	_update_texture()
	_play_audio(audio_deactivate)
	deactivated.emit()

func _check_is_activated() -> void:
	is_active = data_handler.get_value("is_active") or false
	if is_active == false and bodies_count > 0:
		_activate()
	elif is_active == true and bodies_count <= 0:
		_deactivate()

func _play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.play()

func _update_texture() -> void:
	if is_active:
		sprite.region_rect.position.x = rect_offset.position.x - sprite.region_rect.size.x
	else:
		sprite.region_rect.position.x = rect_offset.position.x

func _set_state() -> void:
	is_active = data_handler.get_value("is_active") or false
	_update_texture()
