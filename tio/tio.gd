extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
var maximum_bubbles : int = 10
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var sprite_flip : bool

@onready var bub = load("res://bubble/Bubble.tscn")
var bub_instance
@onready var bubble_timer = $BubbleTimer
@onready var shop_timer = $ShopTimer
@onready var aux_shop_timer = $AuxShopTimer
var backup_velocity : Vector2 = Vector2(0, 0)

var been_to_shops : Array = []
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	z_index = global_position.y - 110
	Events.entered_shop.connect(_on_entered_shop)
	r = rng.randf_range(0.2, 2.0)
	bubble_timer.wait_time = r
	bubble_timer.start()
	backup_velocity = velocity
	$AnimatedSprite2D.flip_h = sprite_flip

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout():
	if (i >= maximum_bubbles - 1):
		return
	i += 1
	bub_instance = bub.instantiate()
	bub_instance.velocity.y = -20 * rng.randf_range(0.8, 1.2)
	bub_instance.global_position = self.global_position
	get_tree().get_root().add_child(bub_instance)
	r = rng.randf_range(0.1, 3.0)
	bubble_timer.wait_time = r
	bubble_timer.start()
	pass # Replace with function body.

func _on_entered_shop(shop : Node, entrate : Node):
	if (self == entrate):
		if !(shop in been_to_shops):
			been_to_shops.append(shop)
			aux_shop_timer.wait_time = rng.randf_range(0.01, 0.4)
			aux_shop_timer.start()

func _on_shop_timer_timeout():
	velocity = backup_velocity

func _on_aux_shop_timer_timeout():
	aux_shop_timer.stop()
	velocity = Vector2(0, 0)
	shop_timer.wait_time = rng.randf_range(3, 4)
	shop_timer.start()
