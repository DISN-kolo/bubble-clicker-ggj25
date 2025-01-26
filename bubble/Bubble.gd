extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var r : float
var i : int = 0
var killable : bool = false
var dying : bool = false
@onready var texture_pool : Array = [
	preload("res://resources/BubbleSmall.png"),
	preload("res://resources/BubbleMed.png"),
	preload("res://resources/BubbleBig.png")]

@onready var g_texture_pool : Array = [
	preload("res://resources/GBubbleSmall.png"),
	preload("res://resources/GBubbleMid.png"),
	preload("res://resources/GBubbleBig.png")]

var is_golden : bool = false

@onready var explosion = preload("res://bubble/explosion.tscn")
var explosion_instance

@onready var b_sprite = $Sprite2D
@onready var b_timer = $Timer

@onready var audio_player = $AudioStreamPlayer2D

var die_roll : float = 100

func _ready():
	if rng.randf_range(0, 100) < Events.golden_bubble_probability * Events.global_bubble_modificator:
		is_golden = true
	Events.global_bubble_count += 1;
	r = rng.randf_range(Events.bubble_growth_time, Events.bubble_growth_time + 2)
	if is_golden:
		b_sprite.texture = g_texture_pool[i]
	else:
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
	if is_golden:
		audio_player.pitch_scale *= 2
	audio_player.play()
	Events.global_bubble_count -= 1;
	killable = false
	dying = true
	b_sprite.queue_free()
	explosion_instance = explosion.instantiate()
	add_child(explosion_instance)
	if is_golden:
		BubblesGlobal.addBubbles(str((i + 1) * Events.global_bubble_modificator * BubblesGlobal.multiplier * Events.golden_bubble_multiplier));
	else:
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
		if is_golden:
			b_sprite.texture = g_texture_pool[i]
		else:
			b_sprite.texture = texture_pool[i]
		b_timer.wait_time = r
		b_timer.start()


func _on_area_2d_mouse_entered():
	if !dying:
		killable = true


func _on_area_2d_mouse_exited():
	if !dying:
		killable = false
