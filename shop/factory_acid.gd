extends Node2D

var launchable : bool = false
var launchable_in_the_future : bool = false
var cooldown : bool = false
var us_fuming : bool = false

@onready var fuming_timer = $FumingTimer
@onready var cooldown_timer = $CooldownTimer
@onready var cooldown_label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.fuming = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Events.fuming and !cooldown and launchable:
		if Input.is_action_just_pressed("LMB"):
			Events.factory_started_fuming.emit()
			fuming_timer.start()
			Events.fuming = true
			us_fuming = true
			launchable = false
	if (cooldown):
		cooldown_label.visible = true
		cooldown_label.text = "Cooldown... " + str(int(cooldown_timer.time_left))
	elif (us_fuming):
		cooldown_label.visible = true
		cooldown_label.text = "  Fuming!"
	else:
		cooldown_label.visible = false

func _on_area_2d_mouse_entered():
	if !us_fuming and !cooldown:
		launchable = true
	else:
		launchable_in_the_future = true

func _on_area_2d_mouse_exited():
	launchable = false
	launchable_in_the_future = false


func _on_fuming_timer_timeout():
	cooldown = true
	Events.fuming = false
	us_fuming = false
	Events.factory_stopped_fuming.emit()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	cooldown = false
	if launchable_in_the_future:
		launchable_in_the_future = false
		launchable = true
