@tool
class_name AbilityPickup extends Node2D

signal picked_up

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var ability_data: AbilityData: set = _set_ability_data
@onready var data_handler: PersistentDataHandler = $DataHandler
@onready var glow_animation: AnimationPlayer = $GlowAnimation

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	data_handler.data_loaded.connect(_set_pickup_state)
	_set_pickup_state()

func _set_pickup_state() -> void:
	if data_handler.get_value("is_picked_up", false):
		_disable_pickup()
		queue_free()
	else:
		visible = true
		if not area_2d.body_entered.is_connected(_on_body_entered):
			area_2d.body_entered.connect(_on_body_entered)

func _disable_pickup() -> void:
	glow_animation.stop(false)
	sprite_2d.queue_free()
	if area_2d.body_entered.is_connected(_on_body_entered):
		area_2d.body_entered.disconnect(_on_body_entered)
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if PlayerManager.player.abilities and ability_data:
			PlayerManager.player.abilities.unlock(ability_data)
			_ability_picked_up()

func _ability_picked_up() -> void:
	if area_2d.body_entered.is_connected(_on_body_entered):
		area_2d.body_entered.disconnect(_on_body_entered)
	if audio_stream_player_2d and audio_stream_player_2d.stream:
		audio_stream_player_2d.play()
	picked_up.emit()
	if audio_stream_player_2d and audio_stream_player_2d.playing:
		await audio_stream_player_2d.finished
	data_handler.set_value("is_picked_up", true)
	_set_pickup_state()

func _set_ability_data(value: AbilityData) -> void:
	ability_data = value
	_update_texture()

func _update_texture() -> void:
	if ability_data and sprite_2d:
		sprite_2d.texture = ability_data.ability_icon
