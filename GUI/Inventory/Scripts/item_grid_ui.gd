class_name ItemGridUI extends GridContainer

const ITEM_SLOT = preload("uid://bsti2e5rmu3ib")

signal focused_slot_changed(slot: ItemSlot)

@export var data: InventoryData

var focused_slot: ItemSlot
var focused_slot_index: int = 0

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	data.changed.connect(_on_inventory_changed)

func _on_inventory_changed() -> void:
	_clear_inventory()
	_update_inventory()

func _visibility_changed() -> void:
	if is_visible_in_tree():
		_update_inventory()
	else:
		focused_slot_index = 0
		focused_slot = null
		_clear_inventory()

func _clear_inventory() -> void:
	for c in get_children():
		if c is ItemSlot:
			if (c as ItemSlot).focus_entered.is_connected(_on_slot_focused):
				(c as ItemSlot).focus_entered.disconnect(_on_slot_focused)
			if (c as ItemSlot).focus_exited.is_connected(_on_slot_unfocused):
				(c as ItemSlot).focus_exited.disconnect(_on_slot_unfocused)
			remove_child(c)
			c.queue_free()

func _update_inventory() -> void:
	for i in data.slots.size():
		var s = data.slots[i]
		var new_slot: ItemSlot = ITEM_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(_on_slot_focused.bind(i, new_slot))
		new_slot.focus_exited.connect(_on_slot_unfocused.bind(i, new_slot))
	if get_child_count() > focused_slot_index:
		get_child(focused_slot_index).grab_focus()

func _on_slot_focused(index: int, slot: ItemSlot) -> void:
	focused_slot = slot
	focused_slot_index = index
	focused_slot_changed.emit(focused_slot)

func _on_slot_unfocused(_index: int, slot: ItemSlot) -> void:
	if focused_slot == slot:
		focused_slot = null
		focused_slot_index = -1
		focused_slot_changed.emit(focused_slot)
		
