class_name BarredDoor extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var data_handler: PersistentDataHandler = $DataHandler

var is_open: bool = false

func _ready() -> void:
	data_handler.data_loaded.connect(set_state)
	set_state()

func _on_open() -> void:
	print("Barred Door - On Open")
	if is_open == false:
		is_open = true
		data_handler.set_value("is_open", is_open)
		animation_player.play("open_door")
	pass

func _on_close() -> void:
	print("Barred Door - On Close")
	if is_open == true:
		is_open = false
		data_handler.set_value("is_open", is_open)
		animation_player.play("close_door")
	pass

func set_state() -> void:
	is_open = data_handler.get_value("is_open") or false
	print("BARRED STATE :: ", is_open)
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
