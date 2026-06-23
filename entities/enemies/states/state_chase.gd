class_name EnemyStateChase extends State

@export var chase_speed: float = 40.0
@export var turn_rate: float = 0.25

@export_category("AI")
@export var vision_area: VisionArea
@export var attack_hitbox: HitBox
@export var state_aggro_duration: float = 5.0
@export var exit_state: String

var _timer: float = 0.0
var _direction: Vector2
var _can_see_player: bool = false

func init(state_machine, entity) -> void:
	super(state_machine, entity)
	if vision_area:
		vision_area.player_entered.connect(_on_player_entered)
		vision_area.player_exited.connect(_on_player_exited)


func enter() -> void:
	_timer = state_aggro_duration
	_entity.update_direction()
	if attack_hitbox:
		attack_hitbox.monitoring = true
	super()

func exit() -> void:
	super()
	if attack_hitbox:
		attack_hitbox.monitoring = false
	_can_see_player = false

func process(delta: float) -> void:
	super(delta)
	var new_dir : Vector2 = _entity.global_position.direction_to(PlayerManager.player.global_position)
	_entity.direction = lerp(_direction, new_dir, turn_rate)
	_entity.velocity = _entity.direction.normalized() * chase_speed
	if _entity.update_direction():
		_entity.update_animation(state_name)
	
	if _can_see_player == false:
		_timer -= delta
		if _timer <= 0:
			_state_machine.change_state(exit_state)
			return
	else:
		_timer = state_aggro_duration

func physics(_delta: float) -> void:
	super(_delta)

func handle_input(_event: InputEvent) -> void:
	super(_event)

func _on_player_entered() -> void:
	_can_see_player = true
	if (
		_state_machine.cur_state is EnemyStateDamaged or
		_state_machine.cur_state is EnemyStateDestroy
	) : return
	_state_machine.change_state(state_name)

func _on_player_exited() -> void:
	_can_see_player = false
	
