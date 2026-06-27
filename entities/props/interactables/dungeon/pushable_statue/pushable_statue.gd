class_name PushableStatue extends RigidBody2D

@export var push_speed: float = 50.0

@onready var audio: AudioStreamPlayer2D = $Audio
@onready var data_handler: PersistentDataHandler = $DataHandler

var push_direction: Vector2 = Vector2.ZERO: set = _set_push_direction

func _ready() -> void:
	_load_position()

func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * push_speed

func _set_push_direction(value: Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
		_save_position()
	else:
		audio.play()

func _save_position() -> void:
	data_handler.set_value("pos_x", global_position.x)
	data_handler.set_value("pos_y", global_position.y)

func _load_position() -> void:
	var pos_x: float = global_position.x
	var pos_y: float = global_position.y
	if data_handler.get_value("pos_x") != null and data_handler.get_value("pos_y") != null:
		pos_x = float(data_handler.get_value("pos_x"))
		pos_y = float(data_handler.get_value("pos_y"))
	global_position = Vector2(pos_x, pos_y)
