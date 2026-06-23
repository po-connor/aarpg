class_name Enemy extends Entity

var player: Player

func _ready() -> void:
	super()
	player = PlayerManager.player
