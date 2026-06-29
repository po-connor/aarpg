class_name PlayerAbilities extends Node2D

const BOOMERANG = preload("uid://du26cejl5ot2v")

enum Abilities { BOOMERANG }

var abilities_dict : Dictionary[int, Callable] = {
	Abilities.BOOMERANG: boomerang_ability 
}

var selected_ability = Abilities.BOOMERANG
var player: Player
var boomerang_instance: Boomerang = null

func _ready() -> void:
	player = PlayerManager.player

func boomerang_ability() -> void:
	if boomerang_instance != null:
		return
	boomerang_instance = BOOMERANG.instantiate()
	add_child(boomerang_instance)
	boomerang_instance.throw()
	boomerang_instance.caught.connect(_destroy_boomerang, CONNECT_ONE_SHOT)

func _destroy_boomerang() -> void:
	remove_child(boomerang_instance)
	boomerang_instance.queue_free()
	boomerang_instance = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability"):
		var ability_callable: Callable = abilities_dict.get(selected_ability)
		if ability_callable:
			ability_callable.call()
