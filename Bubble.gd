extends Node2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
@onready var texture_pool : Array = [
	load("res://resources/BubbleSmall.png"),
	load("res://resources/BubbleMed.png"),
	load("res://resources/BubbleBig.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	r = rng.randf_range(2.0, 3.0)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	i += 1
	if (i >= 3):
		return
	r = rng.randf_range(2.0, 3.0)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
