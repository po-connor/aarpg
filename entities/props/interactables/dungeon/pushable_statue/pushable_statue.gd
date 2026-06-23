class_name PushableStatue extends RigidBody2D

func _ready() -> void:
	add_to_group("pushable")
	pass

func _on_body_entered(_b: Node) -> void:
	print("body entered")
	pass
