class_name PlayerInteractions extends Node2D

@onready var player: Player = $".."

var interactables_in_range: Array[Node2D] = []

func _ready() -> void:
	player.direction_changed.connect(update_direction)

func update_interactables() -> void:
	var alive_interactables: Array[Node2D] = []
	for interactable in interactables_in_range:
		if is_instance_valid(interactable) and interactable.is_inside_tree():
			alive_interactables.append(interactable)
	if alive_interactables.size() != interactables_in_range.size():
		interactables_in_range.clear()
		interactables_in_range.append_array(alive_interactables)

func register(node: Node2D) -> void:
	if not interactables_in_range.has(node):
		interactables_in_range.append(node)
		node.tree_exiting.connect(unregister.bind(node), CONNECT_ONE_SHOT)

func unregister(node: Node2D) -> void:
	var index: int = interactables_in_range.find(node)
	if index >= 0:
		interactables_in_range.remove_at(index)

func update_direction(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = 270
		_:
			rotation_degrees = 0
		
