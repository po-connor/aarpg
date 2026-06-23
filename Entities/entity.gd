class_name Entity extends CharacterBody2D

signal direction_changed(new_direction: Vector2)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: HurtBox = $HurtBox
@onready var state_machine: StateMachine = $StateMachine

@export_category("Entity")
@export var hitbox: HitBox
@export var invulnerable: bool = false
@export var hp: int = 3
@export var max_hp: int = 3

signal entity_damaged(hitbox: HitBox)
signal entity_destroyed(hitbox: HitBox)

func _ready() -> void:
	if state_machine:
		state_machine.initialize(self)
	if hurtbox:
		hurtbox.hurt.connect(_take_damage)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func update_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction: Vector2 = DIR_4[direction_id]

	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	sprite.scale.x = 1 if cardinal_direction == Vector2.RIGHT else -1
	return true

func update_animation(state: String) -> void:
	var animation_name = state + "_" + get_anim_direction()
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)

func get_anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage(source_hitbox: HitBox) -> void:
	if invulnerable:
		return
	if not source_hitbox.damage:
		return
	update_hp(-source_hitbox.damage)
	if hp > 0:
		entity_damaged.emit(source_hitbox)
	else:
		entity_destroyed.emit(source_hitbox)

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)

func make_invulnerable(duration: float) -> void:
	invulnerable = true
	hurtbox.set_deferred("monitorable", false)
	await get_tree().create_timer(duration).timeout
	invulnerable = false
	hurtbox.set_deferred("monitorable", true)
