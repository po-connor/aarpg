class_name Player extends Entity

signal interact_pressed(target: Node2D)

@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var interactions: PlayerInteractions = $Interactions
@onready var interaction_notification: Sprite2D = $InteractionNotification
@onready var abilities: PlayerAbilities = $Abilities

@export var override_death: bool = false

var boomerang: Boomerang

func _ready() -> void:
	super()
	PlayerManager.player = self
	update_hp(0)

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"), 
		Input.get_axis("up", "down")
	).normalized()
	interaction_notification.visible = interactions.interactables_in_range.size() > 0

func interact() -> void:
	var target: InteractionArea = interactions.get_nearest()
	if target == null:
		return
	interact_pressed.emit(target)

func update_hp(delta: int) -> void:
	super(delta)
	if hp == 0 and override_death:
		hp = max_hp
	PlayerHud.update_hp(hp, max_hp)
