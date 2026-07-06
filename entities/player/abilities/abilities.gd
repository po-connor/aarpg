class_name PlayerAbilities extends Node2D

const BOOMERANG_SCENE = preload("uid://du26cejl5ot2v")

const BOOMERANG_ABILITY = preload("uid://c3pknpnqnsy4b")

var boomerang_instance: Boomerang = null

var abilities : Array[AbilitiesArrayItem] = []
var unlocked_abilities : Array[AbilitiesArrayItem] = []
var selected_ability_index: int = 0

func unlock(ability_data: AbilityData) -> void:
	var unlocked_index = _get_ability_index_by_name(unlocked_abilities, ability_data.abiliy_name)
	if unlocked_index > -1:
		return
	var ability_index: int = _get_ability_index_by_name(abilities, ability_data.abiliy_name)
	if ability_index < 0:
		return
	var item: AbilitiesArrayItem = abilities.get(ability_index)
	if not item:
		return
	var inserted: bool = false
	for i in unlocked_abilities.size():
		if abilities.find(unlocked_abilities[i]) > ability_index:
			unlocked_abilities.insert(i, item)
			inserted = true
			break
	if not inserted:
		unlocked_abilities.append(item)
	return

func get_selected() -> AbilityData:
	if unlocked_abilities.get(selected_ability_index):
		var a: AbilitiesArrayItem = unlocked_abilities.get(selected_ability_index)
		if a:
			return a.data
	return null

func cycle(step: int = 1) -> void:
	if unlocked_abilities.size() < 2:
		return
	var next_index = selected_ability_index + step
	if next_index < 0:
		next_index = unlocked_abilities.size() - 1
	elif next_index >= unlocked_abilities.size():
		next_index = 0
	selected_ability_index = next_index

func _filter_is_unlocked(ability: AbilitiesArrayItem) -> bool:
	return ability.unlocked

func _get_ability_index_by_name(array: Array[AbilitiesArrayItem], ability_name: String) -> int:
	for i: int in array.size():
		var a: AbilitiesArrayItem = array.get(i)
		if a and a.data and a.data.abiliy_name == ability_name:
			return i
	return -1

func _ready() -> void:
	_init_ability(BOOMERANG_ABILITY, _boomerang_behavior, false)

func _init_ability(data: AbilityData, behavior: Callable, unlocked: bool):
	var ability: AbilitiesArrayItem = AbilitiesArrayItem.new()
	ability.data = data
	ability.behavior = behavior
	abilities.append(ability)
	if unlocked:
		unlocked_abilities.append(ability)

func _boomerang_behavior() -> void:
	if boomerang_instance != null:
		return
	boomerang_instance = BOOMERANG_SCENE.instantiate()
	get_tree().current_scene.add_child(boomerang_instance)
	boomerang_instance.global_position = global_position
	boomerang_instance.throw()
	boomerang_instance.caught.connect(_destroy_boomerang, CONNECT_ONE_SHOT)
	boomerang_instance.tree_exiting.connect(_destroy_boomerang, CONNECT_ONE_SHOT)

func _destroy_boomerang() -> void:
	if boomerang_instance:
		var instance: Boomerang = boomerang_instance
		boomerang_instance = null
		instance.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_cycle_up"):
		cycle(1)
	if event.is_action_pressed("ability_cycle_down"):
		cycle(-1)
	if event.is_action_pressed("ability_use"):
		if unlocked_abilities.size() <= selected_ability_index:
			return
		var selected_ability: AbilitiesArrayItem = unlocked_abilities.get(selected_ability_index)
		if not selected_ability or not selected_ability.behavior:
			return
		selected_ability.behavior.call()
