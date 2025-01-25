extends Node2D

var launchable : bool = true
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
	if !fuming and !cooldown:
		if Input.is_action_just_pressed("LMB"):
			Events.factory_started_fuming.emit()
			fuming_timer.start()
			fuming = true
	if (cooldown):
		cooldown_label.visible = true
		cooldown_label.text = "Cooldown... " + str(int(cooldown_timer.time_left))
	else:
		cooldown_label.visible = false

func _on_area_2d_mouse_entered():
	if !fuming and !cooldown:
		launchable = true


func _on_area_2d_mouse_exited():
	if !fuming and !cooldown:
		launchable = false


func _on_fuming_timer_timeout():
	cooldown = true
	fuming = false
	Events.factory_stopped_fuming.emit()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	cooldown = false
