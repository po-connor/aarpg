@tool
class_name ItemPickup extends RigidBody2D

signal picked_up

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var item_data: ItemData: set = _set_item_data

var magnet_target: Node2D
var magnet_linear_force: float

func fly_to_target(target: Node2D, linear_force: float = 5000) -> void:
	magnet_target = target
	magnet_linear_force = linear_force
	set_collision_mask_value(5, false)

func _physics_process(_delta: float) -> void:
	if magnet_target and is_instance_valid(magnet_target):
		var dir: Vector2 = global_position.direction_to(magnet_target.global_position)
		constant_force = dir * magnet_linear_force

func _ready() -> void:
	gravity_scale = 0.0
	linear_damp = 5.0
	lock_rotation = true
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data):
				_item_picked_up()

func _item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	await audio_stream_player_2d.finished
	queue_free()

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
