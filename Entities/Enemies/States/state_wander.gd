class_name EnemyStateWander extends State

@export var move_speed: float = 30.0

@export_category("AI")
@export var state_duration_animation_duration: float = 0.7
@export var state_animation_cycles_min: int = 1
@export var state_animation_cycles_max: int = 3
@export var exit_state: String

var _timer: float = 0.0

func enter() -> void:
	_timer = randi_range(state_animation_cycles_min, state_animation_cycles_max) * state_duration_animation_duration
	var rand = randi_range(0, 3)
	_entity.direction = _entity.DIR_4[ rand ]
	_entity.velocity = _entity.direction.normalized() * move_speed
	_entity.update_direction()
	super()

func exit() -> void:
	super()

func process(delta: float) -> void:
	super(delta)
	_timer -= delta
	if _timer <= 0:
		return _state_machine.change_state(exit_state)

func physics(_delta: float) -> void:
	super(_delta)

func handle_input(_event: InputEvent) -> void:
	super(_event)
