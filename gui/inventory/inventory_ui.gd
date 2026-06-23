class_name InventoryUI extends Control

@onready var item_name_label: Label = $VBoxContainer/ItemDescriptionPanel/VBoxContainer/ItemNameLabel
@onready var item_description_label: Label = $VBoxContainer/ItemDescriptionPanel/VBoxContainer/ItemDescriptionLabel
@onready var item_grid_ui: ItemGridUI = $VBoxContainer/ItemGridPanel/ItemGridUI

func _ready() -> void:
	item_grid_ui.focused_slot_changed.connect(_update_focused_slot)

func _update_focused_slot(slot: ItemSlot) -> void:
	if slot and slot.slot_data and slot.slot_data.item_data:
		item_name_label.text = slot.slot_data.item_data.name
		item_description_label.text = slot.slot_data.item_data.description
	else:
		item_name_label.text = ""
		item_description_label.text = ""
