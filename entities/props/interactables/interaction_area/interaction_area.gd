class_name InteractionArea extends Area2D

signal interacted

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerManager.player.interactions.register()
		PlayerManager.player.interact_pressed.connect(_on_player_interact_pressed)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		PlayerManager.player.interactions.unregister()
		PlayerManager.player.interact_pressed.disconnect(_on_player_interact_pressed)

func _on_player_interact_pressed() -> void:
	interacted.emit()
