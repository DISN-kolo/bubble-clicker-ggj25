extends Node2D

var rng = RandomNumberGenerator.new()
var r : float

@onready var bub = preload("res://bubble/Bubble.tscn")
var bub_instance
@onready var bubble_timer = $BubbleSpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	r = rng.randf_range(Events.bath_interval, Events.bath_interval + 0.2)
	bubble_timer.wait_time = r
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bubble_spawn_timer_timeout():
	BubblesGlobal.addBubbles(str((Events.bath_bubbles_amt) * BubblesGlobal.multiplier));
	bub_instance = bub.instantiate()
	bub_instance.position.x = rng.randi_range(6, 9)
	bub_instance.position.y = rng.randi_range(-13, -11)
	add_child(bub_instance)
	bub_instance.die()
	r = rng.randf_range(Events.bath_interval, Events.bath_interval + 0.2)
	bubble_timer.wait_time = r
	bubble_timer.start()
	pass # Replace with function body.
