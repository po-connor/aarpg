extends EnemyStateDestroy

func init(state_machine, entity) -> void:
	super(state_machine, entity)

func enter() -> void:
	super()

func exit() -> void:
	super()

func process(delta: float) -> void:
	super(delta)

func physics(delta: float) -> void:
	super(delta)

func handle_input(event: InputEvent) -> void:
	super(event)

func _on_destroyed(hitbox: HitBox):
	super(hitbox)

func _on_animation_finished(_anim: String):
	super(_anim)
