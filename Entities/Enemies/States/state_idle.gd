class_name EnemyStateIdle extends State

@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var exit_state: String

var _timer: float = 0.0

func enter() -> void:
	super()
	_entity.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)

func exit() -> void:
	super()

func process(delta: float) -> void:
	super(delta)
	_timer -= delta
	
	if _timer <= 0:
		return _state_machine.change_state(exit_state)

func physics(delta: float) -> void:
	super(delta)

func handle_input(event: InputEvent) -> void:
	super(event)
