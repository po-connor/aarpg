class_name State extends Node

@export var state_name: String:
	set(value):
		state_name = value
		update_configuration_warnings()

var _state_machine: StateMachine
var _entity: Entity

func _get_configuration_warnings() -> PackedStringArray:
	if not state_name:
		return ["State Name not set"]
	return []

func _ready() -> void:
	assert(state_name)

func init(state_machine, entity) -> void:
	_state_machine = state_machine
	_entity = entity
	pass

## What happens when the player enter this State
func enter() -> void:
	_entity.update_animation(state_name)

## What happens when the player exits this State
func exit() -> void:
	pass

## What happens during _process update in this State
func process(_delta: float) -> void:
	pass

## What happens during _physics_process update in this State
func physics(_delta: float) -> void:
	pass

## What happens with input events in this State
func handle_input(_event: InputEvent) -> void:
	pass
