extends Node2D

var launchable : bool = false
var launchable_in_the_future : bool = false
var fuming : bool = false
var cooldown : bool = false

@onready var fuming_timer = $FumingTimer
@onready var cooldown_timer = $CooldownTimer
@onready var cooldown_label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !fuming and !cooldown and launchable:
		if Input.is_action_just_pressed("LMB"):
			Events.factory_started_fuming.emit()
			fuming_timer.start()
			fuming = true
			launchable = false
	if (cooldown):
		cooldown_label.visible = true
		cooldown_label.text = "Cooldown... " + str(int(cooldown_timer.time_left))
	else:
		cooldown_label.visible = false

func _on_area_2d_mouse_entered():
	if !fuming and !cooldown:
		launchable = true
	else:
		launchable_in_the_future = true

func _on_area_2d_mouse_exited():
	launchable = false
	launchable_in_the_future = false


func _on_fuming_timer_timeout():
	cooldown = true
	fuming = false
	Events.factory_stopped_fuming.emit()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	cooldown = false
	if launchable_in_the_future:
		launchable_in_the_future = false
		launchable = true
