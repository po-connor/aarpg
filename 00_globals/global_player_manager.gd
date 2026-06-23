extends Node

const PLAYER = preload("uid://b4sse476kdci4")
const INVENTORY_DATA: InventoryData = preload("uid://ditpwkf60oua8")

var player: Player
var player_spawned: bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.5).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func remove_player_instance() -> void:
	if player == null:
		return
	if find_child("Player"):
		remove_child(player)
	player.queue_free()
	player = null
	

func set_player_health(new_hp: int, new_max_hp: int) -> void:
	player.max_hp = new_max_hp
	player.hp = new_hp
	player.update_hp(0)

func set_player_position(new_position: Vector2) -> void:
	player.global_position = new_position

func set_as_parent(node: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	node.add_child(player)

func unparent_player(node: Node2D) -> void:
	if player == null:
		return
	node.remove_child(player)
