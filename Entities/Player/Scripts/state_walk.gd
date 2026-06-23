extends State

@export var move_speed: float = 100.0

func enter() -> void:
	super()

func exit() -> void:
	super()

func process(_delta: float) -> void:
	super(_delta)
	if _entity.direction == Vector2.ZERO:
		_state_machine.change_state("idle")
	_entity.velocity = _entity.direction * move_speed
	if _entity.update_direction():
		_entity.update_animation("walk")

func physics(_delta: float) -> void:
	super(_delta)

func handle_input(_event: InputEvent) -> void:
	super(_event)
	if _event.is_action_pressed("attack"):
		_state_machine.change_state("attack")
