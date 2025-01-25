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
	r = rng.randf_range(Events.bubble_growth_time, Events.bubble_growth_time + 2)
	$Sprite2D.texture = texture_pool[i]
	$Timer.wait_time = r
	$Timer.start()
	pass # Replace with function body.

func _physics_process(delta):
	if killable and !dying:
		if Input.is_action_just_pressed("LMB"):
			die()
	move_and_slide()
	pass
	
func die():
	killable = false
	dying = true
	$Sprite2D.queue_free()
	explosion_instance = explosion.instantiate()
	add_child(explosion_instance)
	BubblesGlobal.addBubbles(str(i + 1));

func _on_timer_timeout():
	if !dying:
		if (i >= 2):
			self.queue_free()
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
