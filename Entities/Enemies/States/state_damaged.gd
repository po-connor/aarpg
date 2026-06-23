class_name EnemyStateDamaged extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var exit_state: String

var _animation_finished: bool = false
var _damage_source: HitBox

func init(state_machine, entity) -> void:
	super(state_machine, entity)
	_entity.entity_damaged.connect(_on_damaged)
	

func enter() -> void:
	_animation_finished = false
	_entity.invulnerable = true
	_entity.direction = _entity.global_position.direction_to(_damage_source.global_position)
	_entity.update_direction()
	_entity.velocity = _entity.direction.normalized() * -knockback_speed
	_entity.animation_player.animation_finished.connect(_on_animation_finished)
	super()

func exit() -> void:
	super()
	_entity.invulnerable = false
	_entity.animation_player.animation_finished.disconnect(_on_animation_finished)

func process(delta: float) -> void:
	super(delta)
	if _animation_finished:
		_state_machine.change_state(exit_state)
	else:
		_entity.velocity -= _entity.velocity * decelerate_speed * delta

func physics(delta: float) -> void:
	super(delta)

func handle_input(event: InputEvent) -> void:
	super(event)

func _on_damaged(hitbox: HitBox):
	_damage_source = hitbox
	_state_machine.change_state(state_name)

func _on_animation_finished(_anim: String):
	_animation_finished = true 
