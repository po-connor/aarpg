# Run script in the editor
@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level
@export var target_transition_area: String = "LevelTransition"
@export var center_player: bool = false

@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 2:
	set(_value):
		size = _value
		_update_area()
@export var step_size: int = 32
@export var side: SIDE = SIDE.LEFT:
	set(_value):
		side = _value
		_update_area()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	monitoring = false
	_place_player()
	await LevelManager.level_loaded
	monitoring = true
	body_entered.connect(_player_entered)

func _update_area() -> void:
	var new_rect : Vector2 = Vector2(step_size, step_size)
	var new_position: Vector2 = Vector2.ZERO
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= step_size * 0.5
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += step_size * 0.5
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= step_size * 0.5
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += step_size * 0.5
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position

func _player_entered(_player: Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area, _get_offset())
	pass

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)

func _get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_position = PlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_position.y - global_position.y
		offset.x = step_size * 0.5
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_position.x - global_position.x
		offset.y = step_size * 0.5
		if side == SIDE.TOP:
			offset.y *= -1
	return offset
