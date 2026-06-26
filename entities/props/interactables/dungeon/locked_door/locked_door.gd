class_name LockedDoor extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var is_open_data: PersistentDataHandler = $IsOpenData

@export var key_item: ItemData
@export var locked_audio: AudioStream
@export var unlock_audio: AudioStream

var is_open: bool = false

func _ready() -> void:
	interaction_area.interacted.connect(_on_player_interact)
	is_open_data.data_loaded.connect(set_state)
	set_state()

func _on_player_interact() -> void:
	if not is_open:
		open_door()

func open_door() -> void:
	if key_item == null:
		return
	var door_unlocked: bool = PlayerManager.INVENTORY_DATA.use_item(key_item)
	
	if door_unlocked:
		animation_player.play("open_door")
		audio.stream = unlock_audio
		is_open_data.set_value()
		is_open = true
		interaction_area.interacted.disconnect(_on_player_interact)
	else:
		audio.stream = locked_audio
	audio.play()


# Currently unused
func close_door() -> void: 
	animation_player.play("close_door")

func set_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
