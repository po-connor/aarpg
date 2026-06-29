class_name Boomerang extends Node2D

signal caught

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox

enum BOOMERANG_STATE { INACTIVE, THROW, RECEIVE }

@export var throw_speed: float = 550.0
@export var throw_acceleration: float = 20.0

var state : BOOMERANG_STATE = BOOMERANG_STATE.THROW
var direction: Vector2
var speed: float
var acceleration: float
var player: Player

func _ready() -> void:
	player = PlayerManager.player
	state = BOOMERANG_STATE.INACTIVE
	visible = false

func _process(delta: float) -> void:
	if state == BOOMERANG_STATE.INACTIVE:
		return
	position += direction * speed * delta
	if state == BOOMERANG_STATE.THROW:
		speed -= acceleration
	else:
		speed += acceleration
		update_receive_direction()
	if state == BOOMERANG_STATE.THROW and speed < 5:
		receive()
	if state == BOOMERANG_STATE.RECEIVE and PlayerManager.player.abilities.global_position.distance_to(global_position) < 15:
		catch()

func update_receive_direction() -> void:
	if state != BOOMERANG_STATE.RECEIVE:
		return
	direction = global_position.direction_to(PlayerManager.player.abilities.global_position)

func throw() -> void:
	if not state == BOOMERANG_STATE.INACTIVE:
		return
	state = BOOMERANG_STATE.THROW
	direction = PlayerManager.player.direction
	if direction == Vector2.ZERO:
		direction = PlayerManager.player.cardinal_direction
	speed = throw_speed
	acceleration = throw_acceleration
	visible = true

func receive() -> void:
	if not state == BOOMERANG_STATE.THROW:
		return
	state = BOOMERANG_STATE.RECEIVE

func catch() -> void:
	if not state == BOOMERANG_STATE.RECEIVE:
		return
	state = BOOMERANG_STATE.INACTIVE
	direction = Vector2.ZERO
	speed = 0
	acceleration = 0
	visible = false
	caught.emit()

func _on_area_entered(a: Area2D) -> void:
	if not a is HurtBox:
		return
