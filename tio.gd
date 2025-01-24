extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
var maximum_bubbles : int = 10
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var bub = load("res://Bubble.tscn")
var bub_instance
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	r = rng.randf_range(0.2, 2.0)
	$Timer.wait_time = r
	$Timer.start()

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
	$Timer.wait_time = r
	$Timer.start()
	pass # Replace with function body.
