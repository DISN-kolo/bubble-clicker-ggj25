extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var sprite_flip : bool

@onready var bub = load("res://bubble/Bubble.tscn")
var bub_instance
@onready var bubble_timer = $BubbleTimer
@onready var shop_timer = $ShopTimer
@onready var aux_shop_timer = $AuxShopTimer
@onready var sprite = $AnimatedSprite2D
var backup_velocity : Vector2 = Vector2(0, 0)

var been_to_shops : Array = []
var in_shop : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	z_index = global_position.y - 110
	Events.entered_shop.connect(_on_entered_shop)
	Events.entered_left_zone.connect(_on_entered_left_zone)
	Events.entered_right_zone.connect(_on_entered_right_zone)
	r = rng.randf_range(Events.tio_bubbling_time, Events.tio_bubbling_time + 0.5)
	bubble_timer.wait_time = r
	bubble_timer.start()
	sprite.flip_h = sprite_flip
	velocity *= rng.randf_range(0.96, 1.04)

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
	sprite.flip_h = velocity.x < 0
	move_and_slide()


func _on_timer_timeout():
	#if (i >= Events.tio_maximum_bubbles - 1):
		#return
	#i += 1
	Events.global_bubble_index += 1
	if Events.global_bubble_index == Events.global_bubble_modificator:
		Events.global_bubble_index = 0
		bub_instance = bub.instantiate()
		bub_instance.velocity.y = -20 * rng.randf_range(0.8, 1.2)
		bub_instance.global_position = self.global_position
		get_tree().get_root().add_child(bub_instance)
	r = rng.randf_range(Events.tio_bubbling_time, Events.tio_bubbling_time + 0.5)
	if in_shop:
		r /= Events.tio_shop_bubble_time_modificator
	bubble_timer.wait_time = r
	bubble_timer.start()

func _on_entered_shop(shop : Node, entrate : Node):
	if (self == entrate):
		if !(shop in been_to_shops):
			backup_velocity = velocity
			been_to_shops.append(shop)
			aux_shop_timer.wait_time = rng.randf_range(0.01, 0.4)
			aux_shop_timer.start()
			in_shop = true

func _on_shop_timer_timeout():
	#shop_timer.stop()
	velocity = backup_velocity
	in_shop = false

func _on_aux_shop_timer_timeout():
	#aux_shop_timer.stop()
	velocity = Vector2(0, 0)
	shop_timer.wait_time = rng.randf_range(Events.tio_shopping_time, Events.tio_shopping_time + 0.5)
	shop_timer.start()

func _on_entered_left_zone(entrante : Node):
	if (self == entrante):
		velocity.x *= -1
		been_to_shops.clear()

func _on_entered_right_zone(entrante : Node):
	if (self == entrante):
		velocity.x *= -1
		been_to_shops.clear()
