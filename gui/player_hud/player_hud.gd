extends CanvasLayer

var hearts : Array[HeartGUI] = []

func _ready() -> void:
	for child in $Control/Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false

func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)
	pass

func update_heart(index: int, hp: int) -> void:
	hearts[index].value = clampi(hp - index * 2, 0, 2)

func update_max_hp(max_hp: int) -> void:
	var hearts_count: int = roundi(max_hp * 0.5)
	for i in hearts.size():
		if i < hearts_count:
			hearts[i].visible = true
