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

@onready var b_sprite = $Sprite2D
@onready var b_timer = $Timer

@onready var audio_player = $AudioStreamPlayer2D

var die_roll : float = 100

func _ready():
	Events.global_bubble_count += 1;
	r = rng.randf_range(Events.bubble_growth_time, Events.bubble_growth_time + 2)
	b_sprite.texture = texture_pool[i]
	b_timer.wait_time = r
	b_timer.start()

func _physics_process(delta):
	if killable and !dying:
		if Input.is_action_just_pressed("LMB"):
			die()
	move_and_slide()

func die():
	audio_player.pitch_scale = rng.randf_range(0.98, 1.02)
	audio_player.play()
	Events.global_bubble_count -= 1;
	killable = false
	dying = true
	b_sprite.queue_free()
	explosion_instance = explosion.instantiate()
	add_child(explosion_instance)
	BubblesGlobal.addBubbles(str((i + 1) * Events.global_bubble_modificator * BubblesGlobal.multiplier));

func _on_timer_timeout():
	if !dying:
		if (i >= 2):
			self.queue_free()
			return
		die_roll = rng.randf_range(0, 100)
		if (die_roll < Events.bubble_random_death_chance):
			die()
			return
		i += 1
		r = rng.randf_range(2.0, 3.0)
		b_sprite.texture = texture_pool[i]
		b_timer.wait_time = r
		b_timer.start()


func _on_area_2d_mouse_entered():
	if !dying:
		killable = true


func _on_area_2d_mouse_exited():
	if !dying:
		killable = false
