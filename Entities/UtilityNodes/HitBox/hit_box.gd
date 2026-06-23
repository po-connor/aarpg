class_name HitBox extends Area2D

signal hit_landed(hutbox: HurtBox)

@export_category("HitBox")
@export var damage: int = 1

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not area is HurtBox:
		return
	var hurtbox: HurtBox = area
	hurtbox.receive_hit(self)
	hit_landed.emit(hurtbox)
