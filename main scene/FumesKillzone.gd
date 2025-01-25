extends Area2D

@onready var main_fumes_sprite = $fumeSprite
@onready var aux_fumes_sprite = $fumeSpriteShifted

var tween_showup : Tween
var tween_fade : Tween

var modulate_color : Color = Color("d9ff00ad")
var opacity : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	main_fumes_sprite.self_modulate.a = opacity
	aux_fumes_sprite.self_modulate.a = opacity
	main_fumes_sprite.modulate = modulate_color
	aux_fumes_sprite.modulate = modulate_color
	Events.factory_started_fuming.connect(_on_factory_started_fuming)
	Events.factory_stopped_fuming.connect(_on_factory_stopped_fuming)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	main_fumes_sprite.position.x -= delta * Events.wind_speed
	aux_fumes_sprite.position.x -= delta * Events.wind_speed
	if main_fumes_sprite.position.x <= -480:
		main_fumes_sprite.position.x = 0
	if aux_fumes_sprite.position.x <= 0:
		aux_fumes_sprite.position.x = 480
	main_fumes_sprite.self_modulate.a = opacity
	aux_fumes_sprite.self_modulate.a = opacity


func _on_body_entered(body):
	#print("enter ", body, " from group ", body.get_groups())
	if body.is_in_group("bubble"):
		if !body.dying:
			body.die()

func _on_factory_started_fuming():
	monitoring = true
	#print("started fuming, monitoring on? ", monitoring)
	tween_showup = create_tween()
	tween_showup.tween_property(self, "opacity", 1, 0.5)

func _on_factory_stopped_fuming():
	monitoring = false
	tween_fade = create_tween()
	tween_fade.tween_property(self, "opacity", 0, 0.5)
