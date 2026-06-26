class_name BarredDoor extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _on_open() -> void:
	if is_open == false:
		is_open = true
		animation_player.play("open_door")
	pass

func _on_close() -> void:
	if is_open == true:
		is_open = false
		animation_player.play("close_door")
	pass
