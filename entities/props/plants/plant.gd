class_name Plant extends Node2D

func _ready() -> void:
	$HurtBox.hurt.connect(take_damage)

func take_damage(_hitbox: HitBox) -> void:
	queue_free()
