extends Node2D
var rng = RandomNumberGenerator.new()
var r : float

@onready var cloud= preload("res://main scene/cloud.tscn")
var instance_of_cloud
var cloud_direction : int
const CLOUD_MIN_Y : int = -90
const CLOUD_MAX_Y : int = 20
const CLOUD_SPEED : float = 5.5

@onready var tio = preload("res://tio/tio.tscn")
var instance_of_tio
var tio_direction : int
@onready var shop = preload("res://shop/fun_shop.tscn")
var instance_of_shop
@onready var factory = preload("res://shop/factory_acid.tscn")
var instance_of_factory
@onready var bath = preload("res://shop/auto_bath.tscn")
var instance_of_bath

var bath_installed : bool = false
var factories_spawned : int = 0
var shops_spawned : int = 0

const MAX_FACTORIES : int = 3
const MAX_SHOPS : int = 5

var factory_coordinates : Array[Vector2]
var shop_coordinates : Array[Vector2]

@onready var cloud_spawner_timer = $Timer
@onready var bubbles_count = $BubblesCount

const TIO_SPEED : float = 50
const TIO_MIN_Y : float = 110
const TIO_MAX_Y : float = 120

func _factory_coordinates_generator():
	for i in range(MAX_FACTORIES + 1):
		factory_coordinates.append(Vector2(-200 + 400 / MAX_FACTORIES * i, 50))

func _shops_coordinates_generator():
	for i in range(MAX_SHOPS + 1):
		shop_coordinates.append(Vector2(-180 + 360 / MAX_SHOPS * i, rng.randi_range(110, 120)))


# Called when the node enters the scene tree for the first time.
func _ready():
	_factory_coordinates_generator()
	_shops_coordinates_generator()
	BubblesGlobal.upgrade_purchased.connect(_on_upgrade_purchased)
	spawn_a_tio()
	spawn_a_cloud()
	#instance_of_shop = shop.instantiate()
	#instance_of_shop.global_position = Vector2(rng.randi_range(-100, 100), rng.randi_range(110, 120))
	#add_child(instance_of_shop)
	#instance_of_factory = factory.instantiate()
	#instance_of_factory.global_position = Vector2(-100, 50)
	#add_child(instance_of_factory)

func _process(delta):
	if Input.is_action_just_pressed("shiftescape"):
		get_tree().quit()
	if Input.is_action_just_pressed("cheat"):
		Events.tio_spawn_time /= 2
		if (Events.tio_spawn_time <= 0.5):
			Events.tio_spawn_time = 0.5
		Events.bubble_growth_time /= 2
		if (Events.bubble_growth_time <= 0.1):
			Events.bubble_growth_time = 0.1
		Events.tio_shopping_time += 0.5
		if (Events.tio_shopping_time > 3):
			Events.tio_shopping_time = 3
		Events.tio_bubbling_time /= 2
		if (Events.tio_bubbling_time <= 0.3):
			Events.tio_bubbling_time = 0.3
		#Events.tio_maximum_bubbles += 1
	if Events.global_bubble_count > 300:
		Events.global_bubble_modificator *= 3
		Events.global_bubble_count = 0

func _on_killzone_tio_left_body_entered(body):
	if body.is_in_group("cloud"):
		body.queue_free()
	Events.entered_left_zone.emit(body)

func _on_killzone_tio_right_body_entered(body):
	if body.is_in_group("cloud"):
		body.queue_free()
	Events.entered_right_zone.emit(body)

func _on_killzone_bubble_top_body_entered(body):
	body.queue_free()

func _on_upgrade_purchased(upgrade_name : String):
	if upgrade_name == "Tios":
		spawn_a_tio()
	elif upgrade_name == "Fun shop":
		spawn_a_shop()
	elif upgrade_name == "Acid factory":
		spawn_a_factory()
	elif upgrade_name == "Bubble x2":
		upgrade_multiplier()
	elif upgrade_name == "Random pops":
		Events.bubble_random_death_chance += Events.bubble_random_death_chance + 0.5
	elif upgrade_name == "Auto bath":
		bath_upgrade_or_install()
	elif upgrade_name == "Reduce wait":
		Events.tio_bubbling_time /= 1.2
		if (Events.tio_bubbling_time <= 0.5):
			Events.tio_bubbling_time = 0.5

func spawn_a_tio():
	tio_direction = rng.randi_range(0, 1) * 2 - 1
	instance_of_tio = tio.instantiate()
	instance_of_tio.velocity.x = TIO_SPEED * tio_direction
	instance_of_tio.global_position = Vector2(-250 * tio_direction, rng.randi_range(TIO_MIN_Y, TIO_MAX_Y))
	instance_of_tio.sprite_flip = (tio_direction == -1)
	add_child(instance_of_tio)

func spawn_a_shop():
	if (shops_spawned >= MAX_SHOPS + 1):
		return
	instance_of_shop = shop.instantiate()
	instance_of_shop.global_position = shop_coordinates[shops_spawned]
	shops_spawned += 1
	add_child(instance_of_shop)

func spawn_a_factory():
	if (factories_spawned >= MAX_FACTORIES + 1):
		return
	instance_of_factory = factory.instantiate()
	instance_of_factory.global_position = factory_coordinates[factories_spawned]
	factories_spawned += 1
	add_child(instance_of_factory)

func spawn_a_cloud():
	cloud_direction = rng.randi_range(0, 1) * 2 - 1
	instance_of_cloud = cloud.instantiate()
	instance_of_cloud.sprite_index = rng.randi_range(0, 1)
	instance_of_cloud.global_position = Vector2(-280 * cloud_direction, rng.randi_range(CLOUD_MIN_Y, CLOUD_MAX_Y))
	instance_of_cloud.velocity.x = CLOUD_SPEED * cloud_direction
	add_child(instance_of_cloud)

func upgrade_multiplier():
	if (BubblesGlobal.multiplier == 1):
		BubblesGlobal.multiplier += 1;
	else:
		BubblesGlobal.multiplier = BubblesGlobal.multiplier**1.65/2 + BubblesGlobal.multiplier;

func bath_upgrade_or_install():
	if !bath_installed:
		instance_of_bath = bath.instantiate()
		instance_of_bath.position.x = 200
		instance_of_bath.position.y = 100
		add_child(instance_of_bath)
		bath_installed = true
	else:
		Events.bath_bubbles_amt *= 1.2
		Events.bath_interval /= 1.3
		if Events.bath_interval < 0.2:
			Events.bath_interval = 0.2

func _on_timer_timeout():
	spawn_a_cloud()
	cloud_spawner_timer.wait_time = rng.randf_range(10, 30)
	cloud_spawner_timer.start()
	pass # Replace with function body.
