extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
var killable : bool = false
var dying : bool = false
@onready var texture_pool : Array = [
	load("res://resources/BubbleSmall.png"),
	load("res://resources/BubbleMed.png"),
	load("res://resources/BubbleBig.png")]

@onready var explosion = preload("res://bubble/explosion.tscn")
var explosion_instance

func _ready():
	r = rng.randf_range(2.0, 3.0)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
	pass # Replace with function body.

func _physics_process(delta):
	if killable and !dying:
		if Input.is_action_just_pressed("LMB"):
			killable = false
			dying = true
			$Sprite2D.queue_free()
			explosion_instance = explosion.instantiate()
			add_child(explosion_instance)
			get_tree().get_nodes_in_group("BubblesCount")[0].addBubbles("1");
	move_and_slide()
	pass

func _on_timer_timeout():
	if !dying:
		if (i >= 2):
			return
		i += 1
		r = rng.randf_range(2.0, 3.0)
		$Sprite2D.texture = texture_pool[i]
		$Timer.wait_time = r
		$Timer.start()


func _on_area_2d_mouse_entered():
	if !dying:
		killable = true


func _on_area_2d_mouse_exited():
	if !dying:
		killable = false
