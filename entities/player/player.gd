class_name Player extends Entity

@warning_ignore("unused_signal")
signal interact_pressed

@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer

@export var override_death: bool = false
@export var push_force: float = 5.0

func _ready() -> void:
	super()
	PlayerManager.player = self
	update_hp(0)

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")
	).normalized()

func update_hp(delta: int) -> void:
	super(delta)
	if hp == 0 and override_death:
		hp = max_hp
	PlayerHud.update_hp(hp, max_hp)
