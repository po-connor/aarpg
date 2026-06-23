class_name InventoryData extends Resource

@export var slots: Array[ItemSlotData]

func _init() -> void:
	_connect_slots()

func _connect_slots() -> void:
	for s in slots:
		if s != null:
			s.changed.connect(_slot_changed)

func _slot_changed() -> void:
	for s in slots:
		if s != null:
			if s.quantity < 1:
				s.changed.disconnect(_slot_changed)
				var index = slots.find(s)
				slots[index] = null
				emit_changed()

func add_item(item: ItemData, quantity: int = 1) -> bool:
	for s in slots:
		if s != null:
			if s.item_data == item:
				s.quantity += quantity
				return true
	for i in slots.size():
		if slots[i] == null:
			var new: ItemSlotData = ItemSlotData.new()
			new.item_data = item
			new.quantity = quantity
			new.changed.connect(_slot_changed)
			slots[i] = new
			return true
	print("Inventory is full!")
	return false

func get_saved_data() -> Array:
	var items_saved: Array = []
	for i in slots.size():
		items_saved.append(_format_item_to_save(slots[i]))
	return items_saved

func _format_item_to_save(slot: ItemSlotData) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_saved_items(saved_data: Array) -> void:
	var array_size: int = slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in saved_data.size():
		slots[i] = _format_item_from_save(saved_data[i])
	_connect_slots()


func _format_item_from_save(saved_object: Dictionary) -> ItemSlotData:
	if saved_object.item == "":
		return null
	var new_slot_data : ItemSlotData = ItemSlotData.new()
	new_slot_data.item_data = load(saved_object.item)
	new_slot_data.quantity = int(saved_object.quantity)
	return new_slot_data
	
