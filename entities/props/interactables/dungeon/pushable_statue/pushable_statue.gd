class_name PushableStatue extends RigidBody2D

@export var push_speed: float = 50.0

@onready var audio: AudioStreamPlayer2D = $Audio

var push_direction: Vector2 = Vector2.ZERO: set = _set_push_direction

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * push_speed

func _set_push_direction(value: Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	
