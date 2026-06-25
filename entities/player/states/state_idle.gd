extends State

func enter() -> void:
	super()

func exit() -> void:
	super()

func process(_delta: float) -> void:
	super(_delta)
	if _entity.direction != Vector2.ZERO:
		_state_machine.change_state("walk")
	_entity.velocity = Vector2.ZERO

func physics(_delta: float) -> void:
	super(_delta)

func handle_input(_event: InputEvent) -> void:
	super(_event)
	if _event.is_action_pressed("attack"):
		_state_machine.change_state("attack")
	if _event.is_action_pressed("interact"):
		(_entity as Player).interact()
		#(_entity as Player).interact_pressed.emit()
