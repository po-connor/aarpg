@tool
class_name TreasureChest extends Node2D

@export var item_data : ItemData: set = _set_item_data
@export var quantity: int = 1: set = _set_quantity

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var chest_sprite: Sprite2D = $ChestSprite
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var quantity_label: Label = $ItemSprite/QuantityLabel
@onready var data_handler: PersistentDataHandler = $DataHandler

var is_open: bool = false

func _ready() -> void:
	_update_quantity_label()
	_update_texture()
	if Engine.is_editor_hint():
		return
	interaction_area.interacted.connect(_on_player_interact, CONNECT_ONE_SHOT)
	data_handler.data_loaded.connect(_set_chest_state)
	_set_chest_state()

func _set_chest_state() -> void:
	is_open = data_handler.get_value("is_open", false)
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")

func _on_player_interact() -> void:
	if is_open:
		return
	is_open = true
	data_handler.set_value("is_open", is_open)
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	else:
		printerr("No Item in Chest!")
		push_error("No Item in Chest! Chest Name: ", name)
	interaction_area.queue_free()

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _set_quantity(value: int) -> void:
	quantity = value
	_update_quantity_label()

func _update_texture() -> void:
	if item_sprite:
		if item_data:
			item_sprite.texture = item_data.texture
		else:
			item_sprite.texture = null

func _update_quantity_label() -> void:
	if quantity_label:
		if item_data == null or quantity <= 1:
			quantity_label.text = ""
		else:
			quantity_label.text = "x" + str(quantity)
