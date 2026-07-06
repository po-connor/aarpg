class_name PersistentDataHandler extends Node

signal data_loaded

var data: Dictionary = {}

func get_value(key: String, default: Variant = null) -> Variant:
	if data.has(key):
		return data.get(key)
	return default

func set_value(key: String, value: Variant) -> void:
	data.set(key, value)
	_set_save_data()

func _ready() -> void:
	_get_save_data()

func _get_name() -> String:
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name

func _get_save_data() -> void:
	var saved_data: Dictionary = SaveManager.get_persistent_data(_get_name())
	if not saved_data.is_empty():
		data = saved_data
		data_loaded.emit()

func _set_save_data() -> void:
	SaveManager.save_persistent_data(_get_name(), data)
