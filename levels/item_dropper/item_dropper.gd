@tool
class_name ItemDropper extends Node2D

const PICKUP = preload("uid://bw6tim3l0sepa")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer = $Audio
@onready var data_handler: PersistentDataHandler = $DataHandler

@export var item_data: ItemData: set = _set_item_data

var has_dropped: bool = false

func drop_item() -> void:
	if has_dropped:
		return
	has_dropped = true
	var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data
	add_child(drop)
	audio.play()
	drop.picked_up.connect(_on_picked_up)

func _on_picked_up() -> void:
	data_handler.set_value("has_dropped", true)

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_texture()
		return
	sprite_2d.visible = false
	data_handler.data_loaded.connect(_on_data_loaded)
	_on_data_loaded()

func _set_item_data(value: ItemData) -> void:
	item_data = value
	if Engine.is_editor_hint():
		_update_texture()
		return

func _update_texture() -> void:
	if Engine.is_editor_hint():
		if item_data and sprite_2d:
			sprite_2d.texture = item_data.texture
		return

func _on_data_loaded() -> void:
	has_dropped = data_handler.get_value("has_dropped", false)
