class_name EnemyStateDestroy extends State

const PICKUP = preload("uid://bw6tim3l0sepa")

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var exit_state: String

@export_category("Item Drops")
@export var drops: Array[DropData]

var _damage_source: HitBox

func init(state_machine, entity) -> void:
	super(state_machine, entity)
	_entity.entity_destroyed.connect(_on_destroyed)

func enter() -> void:
	_entity.invulnerable = true
	if _entity.hitbox:
		_entity.hitbox.monitoring = false
	_entity.direction = _entity.global_position.direction_to(_damage_source.global_position)
	_entity.update_direction()
	_entity.velocity = _entity.direction.normalized() * -knockback_speed
	if _entity.animation_player:
		_entity.animation_player.animation_finished.connect(_on_animation_finished)
	drop_items()
	super()

func exit() -> void:
	super()

func process(delta: float) -> void:
	super(delta)
	_entity.velocity -= _entity.velocity * decelerate_speed * delta

func physics(delta: float) -> void:
	super(delta)

func handle_input(event: InputEvent) -> void:
	super(event)

func _on_destroyed(hitbox: HitBox):
	_damage_source = hitbox
	_state_machine.change_state(state_name)

func _on_animation_finished(_anim: String):
	_entity.queue_free()

func drop_items() -> void:
	if drops.size() == 0:
		return
	for drop in drops:
		if drop == null or drop.item == null:
			continue
		var drop_count : int = drop.get_drop_count()
		for i in drop_count:
			var drop_instance: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop_instance.item_data = drop.item
			var pos: Vector2 = _entity.global_position
			var parent: Node2D = _entity.get_parent()
			parent.call_deferred("add_child", drop_instance)
			drop_instance.call_deferred("set", "global_position", pos)
			drop_instance.call_deferred("set", "linear_velocity", _entity.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5))
