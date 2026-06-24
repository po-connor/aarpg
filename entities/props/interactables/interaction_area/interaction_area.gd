class_name InteractionArea extends Area2D

signal interacted

@export var center_player: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _on_area_entered(area: PlayerInteractionArea) -> void:
	if area is PlayerInteractionArea:
		PlayerManager.player.interactions.register(self)
		PlayerManager.player.interact_pressed.connect(_on_player_interact_pressed)

func _on_area_exited(area: PlayerInteractionArea) -> void:
	if area is PlayerInteractionArea:
		PlayerManager.player.interactions.unregister(self)
		PlayerManager.player.interact_pressed.disconnect(_on_player_interact_pressed)

func _on_player_interact_pressed(target: InteractionArea) -> void:
	if target == self:
		interacted.emit()
