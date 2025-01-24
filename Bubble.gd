extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
@onready var texture_pool : Array = [
	load("res://resources/BubbleSmall.png"),
	load("res://resources/BubbleMed.png"),
	load("res://resources/BubbleBig.png")]

func _ready():
	r = rng.randf_range(2.0, 3.0)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide()
	pass

func _on_timer_timeout():
	if (i >= 2):
		return
	i += 1
	r = rng.randf_range(2.0, 3.0)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
