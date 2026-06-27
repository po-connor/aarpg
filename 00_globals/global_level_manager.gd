
extends Node

signal level_load_started
signal level_loaded
signal tile_map_bounds_changed(bounds: Array[Vector2])

var current_tilemap_bounds: Array[Vector2]
var target_transition: String
var position_offset: Vector2
var is_transitioning: bool = false

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_tile_map_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tile_map_bounds_changed.emit(bounds)

func load_new_level(
	level_path: String,
	new_target_transition: String,
	new_position_offset: Vector2
) -> void:
	is_transitioning = true
	get_tree().paused = true
	target_transition = new_target_transition
	position_offset = new_position_offset
	await SceneTransition.fade_out()
	level_load_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await SceneTransition.fade_in()
	get_tree().paused = false
	is_transitioning = false
	await get_tree().process_frame
	level_loaded.emit()
