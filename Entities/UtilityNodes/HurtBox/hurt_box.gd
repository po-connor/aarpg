class_name HurtBox extends Area2D

signal hurt(hitbox: HitBox)

func receive_hit(hitbox: HitBox) -> void:
	hurt.emit(hitbox)
