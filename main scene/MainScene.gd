extends Node2D
var rng = RandomNumberGenerator.new()
var r : float
@onready var tio = preload("res://tio/tio.tscn")
var instance_of_tio
@onready var shop = preload("res://shop/fun_shop.tscn")
var instance_of_shop
var tio_direction : int

@onready var tio_spawner_timer = $Timer

const TIO_SPEED : float = 50
const TIO_MIN_Y : float = 110
const TIO_MAX_Y : float = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	#instance_of_shop = shop.instantiate()
	#instance_of_shop.global_position = Vector2(rng.randi_range(-100, 100), rng.randi_range(110, 120))
	#add_child(instance_of_shop)
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("cheat"):
		Events.tio_spawn_time /= 2
		if (Events.tio_spawn_time <= 0.01):
			Events.tio_spawn_time = 0.01
		Events.bubble_growth_time /= 2
		if (Events.bubble_growth_time <= 0.01):
			Events.bubble_growth_time = 0.01
		Events.tio_shopping_time += 1
		Events.tio_bubbling_time /= 2
		if (Events.tio_bubbling_time <= 0.01):
			Events.tio_bubbling_time = 0.01
		Events.tio_maximum_bubbles += 1

func _on_timer_timeout():
	tio_direction = rng.randi_range(0, 1) * 2 - 1
	instance_of_tio = tio.instantiate()
	instance_of_tio.velocity.x = TIO_SPEED * tio_direction
	instance_of_tio.global_position = Vector2(-250 * tio_direction, rng.randi_range(TIO_MIN_Y, TIO_MAX_Y))
	instance_of_tio.sprite_flip = (tio_direction == -1)
	add_child(instance_of_tio)
	r = rng.randf_range(Events.tio_spawn_time, Events.tio_spawn_time + 0.5)
	tio_spawner_timer.wait_time = r
	tio_spawner_timer.start()

func _on_killzone_tio_left_body_entered(body):
	body.queue_free()

func _on_killzone_tio_right_body_entered(body):
	body.queue_free()

func _on_killzone_bubble_top_body_entered(body):
	body.queue_free()
