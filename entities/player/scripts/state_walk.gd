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
	if _entity.has_collided:
		_handle_collisions()

func _handle_collisions() -> void:
	for i in _entity.get_slide_collision_count():
		var collision = _entity.get_slide_collision(i)
		var collider = collision.get_collider() as PhysicsBody2D
		if collider and collider.is_in_group("pushable"):
			collider.apply_central_impulse(_entity.cardinal_direction * (_entity as Player).push_force)

func handle_input(_event: InputEvent) -> void:
	super(_event)
	if _event.is_action_pressed("attack"):
		_state_machine.change_state("attack")
	if _event.is_action_pressed("interact"):
		(_entity as Player).interact_pressed.emit()
