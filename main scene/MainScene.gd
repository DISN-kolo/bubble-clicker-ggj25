extends Node2D
var rng = RandomNumberGenerator.new()
var r : float
@onready var tio = preload("res://tio/tio.tscn")
var instance_of_tio
@onready var shop = preload("res://shop/fun_shop.tscn")
var instance_of_shop
var tio_direction : int
# Called when the node enters the scene tree for the first time.
func _ready():
	instance_of_shop = shop.instantiate()
	instance_of_shop.global_position = Vector2(rng.randi_range(-100, 100), rng.randi_range(110, 120))
	add_child(instance_of_shop)
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	

func _on_timer_timeout():
	tio_direction = rng.randi_range(0, 1) * 2 - 1
	instance_of_tio = tio.instantiate()
	instance_of_tio.velocity.x = 50 * tio_direction
	instance_of_tio.global_position = Vector2(-250 * tio_direction, rng.randi_range(110, 120))
	instance_of_tio.sprite_flip = (tio_direction == -1)
	add_child(instance_of_tio)
	r = rng.randf_range(0.3, 1.3)
	$Timer.wait_time = r
	$Timer.start()

func _on_killzone_tio_left_body_entered(body):
	body.queue_free()

func _on_killzone_tio_right_body_entered(body):
	body.queue_free()

func _on_killzone_bubble_top_body_entered(body):
	body.queue_free()
