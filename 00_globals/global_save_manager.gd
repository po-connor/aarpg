extends Node

const SAVE_PATH: String = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = {},
	quests = [],
	abilities = []
}

func save_file_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH + "save.sav")
 
func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	update_abilities()
	var file: FileAccess = FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json: String = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()

func load_game() -> void:
	var file : FileAccess = FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ)
	if file == null:
		return
	var json: JSON = JSON.new()
	json.parse(file.get_line())
	current_save = json.get_data() as Dictionary
	
	PlayerManager.remove_player_instance()
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	PlayerManager.add_player_instance()
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_player_health(current_save.player.hp, current_save.player.max_hp)
	PlayerManager.INVENTORY_DATA.parse_saved_items(current_save.items)
	if current_save.abilities:
		for path in current_save.abilities:
			var ability: AbilityData = load(path)
			if ability:
				PlayerManager.player.abilities.unlock(ability)
	await LevelManager.level_loaded
	game_loaded.emit()

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_saved_data()

func update_abilities() -> void:
	current_save.abilities = PlayerManager.player.abilities.unlocked_abilities.map(
		func(a): return a.data.resource_path
	)

func save_persistent_data(key: String, value: Dictionary) -> void:
	current_save.persistence.set(key, value)

func get_persistent_data(key: String) -> Dictionary:
	return current_save.persistence.get(key, {})
