class_name ItemSlot extends Button

@onready var item_texture: TextureRect = $ItemTexture
@onready var item_quantity_label: Label = $ItemQuantityLabel

var slot_data: ItemSlotData: set = set_slot_data

func _ready() -> void:
	item_texture.texture = null
	item_quantity_label.text = ""
	pressed.connect( _item_pressed )

func set_slot_data(value: ItemSlotData) -> void:
	slot_data = value
	if slot_data == null:
		return
	item_texture.texture = slot_data.item_data.texture
	item_quantity_label.text = str(slot_data.quantity)

func _item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			item_quantity_label.text = str(slot_data.quantity)
