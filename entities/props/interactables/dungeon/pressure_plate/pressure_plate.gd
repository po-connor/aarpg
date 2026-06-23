class_name PressurePlate extends Node2D

signal activated
signal deactivated

@onready var sprite: Sprite2D = $Sprite
@onready var area: Area2D = $Area
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var audio_activate: AudioStream = preload("uid://cdttxq0ck6vdk")
@onready var audio_deactivate: AudioStream = preload("uid://da1nerjhtmrbm")

var bodies_count: int = 0
var is_active: bool = false
var rect_offset: Rect2

func _ready() -> void:
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	if sprite:
		rect_offset = sprite.region_rect

func _on_body_entered(_body: Node2D) -> void:
	bodies_count += 1
	check_is_activated()

func _on_body_exited(_body: Node2D) -> void:
	bodies_count -= 1
	check_is_activated()

func check_is_activated() -> void:
	if is_active == false and bodies_count > 0:
		is_active = true
		sprite.region_rect.position.x = rect_offset.position.x - sprite.region_rect.size.x
		play_audio(audio_activate)
		activated.emit()
	elif is_active == true and bodies_count <= 0:
		is_active = false
		sprite.region_rect.position.x = rect_offset.position.x
		play_audio(audio_deactivate)
		deactivated.emit()

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream
	audio.play()
