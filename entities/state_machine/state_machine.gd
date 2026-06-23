class_name StateMachine extends Node

var states: Dictionary[String, State]
var prev_state_name: String
var cur_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if cur_state:
		cur_state.process(delta)

func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if cur_state:
		cur_state.handle_input(event)

func initialize(_entity: Entity) -> void:
	states = {}
	for child in get_children():
		if child is State:
			var state: State = child
			state.init(self, _entity)
			states.set(state.state_name, state)
	if states.is_empty() == false:
		change_state("idle")
		process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state_name: String) -> void:
	if states.has(new_state_name) == false:
		return
	
	if cur_state:
		cur_state.exit()
		prev_state_name = cur_state.state_name
	cur_state = states.get(new_state_name)
	cur_state.enter()
