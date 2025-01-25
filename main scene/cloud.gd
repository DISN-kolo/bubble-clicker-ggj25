extends CharacterBody2D

var sprite_index : int = 0

@onready var sprite_pool = [
	preload("res://resources/Cloud1.png"),
	preload("res://resources/Cloud2.png")
]

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = sprite_pool[sprite_index]

func _physics_process(delta):

	move_and_slide()
