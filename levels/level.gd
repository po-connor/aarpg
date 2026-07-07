class_name Level extends Node2D

@export var background_music: AudioStream

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	if background_music:
		AudioManager.play_music(background_music)

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()
