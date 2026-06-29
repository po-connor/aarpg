class_name ItemMagnet extends Area2D
@onready var audio: AudioStreamPlayer2D = $Audio

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is ItemPickup:
		return
	var item_pickup: ItemPickup = body as ItemPickup
	item_pickup.fly_to_target(PlayerManager.player)
	if audio:
		audio.play(0)
