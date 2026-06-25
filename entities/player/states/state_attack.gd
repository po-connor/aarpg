extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_effect_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AttackEffectAnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hit_box: HitBox = $"../../Sprite2D/HitBox"

@export var attack_sound: AudioStream
@export_range(1,20,0.5) var decelerate_speed: float = 10.0

var attacking: bool = false

func enter() -> void:
	super()
	attack_effect_animation_player.play("attack_" + _entity.get_anim_direction())
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play(0)
	animation_player.animation_finished.connect(_end_attack)
	attacking = true
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hit_box.monitoring = true

func exit() -> void:
	super()
	animation_player.animation_finished.disconnect(_end_attack)
	attacking = false
	hit_box.monitoring = false

func process(_delta: float) -> void:
	super(_delta)
	#_entity.velocity = Vector2.ZERO
	_entity.velocity -= _entity.velocity * decelerate_speed * _delta
	if attacking == false:
		if _entity.direction == Vector2.ZERO:
			_state_machine.change_state("idle")
		else:
			_state_machine.change_state("walk")

func physics(_delta: float) -> void:
	super(_delta)

func handle_input(_event: InputEvent) -> void:
	super(_event)

func _end_attack(_anim_name: StringName) -> void:
	attacking = false
