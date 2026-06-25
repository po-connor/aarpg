class_name LevelTileMap extends TileMapLayer

func _ready() -> void:
	rendering_quadrant_size = 32
	LevelManager.change_tile_map_bounds(get_tile_map_bounds())

func get_tile_map_bounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = [
		Vector2(get_used_rect().position * rendering_quadrant_size),
		Vector2(get_used_rect().end * rendering_quadrant_size)
	]
	return bounds
