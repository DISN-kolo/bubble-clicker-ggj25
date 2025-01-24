extends Node2D

@onready var tio = preload("res://tio.tscn")
var instance_of_tio
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	

func _on_timer_timeout():
	instance_of_tio = tio.instantiate()
	instance_of_tio.velocity.x = 20
	add_child(instance_of_tio)
	$Timer.start()

func _on_killzone_tio_left_body_entered(body):
	body.queue_free()

func _on_killzone_tio_right_body_entered(body):
	body.queue_free()
