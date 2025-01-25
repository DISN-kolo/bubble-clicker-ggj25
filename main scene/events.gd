extends Node

signal entered_shop
signal entered_left_zone
signal entered_right_zone
signal factory_started_fuming
signal factory_stopped_fuming

var tio_spawn_time : float = 3.0
var bubble_growth_time : float = 3.0
var tio_bubbling_time : float = 1.5
var tio_shopping_time : float = 3.5
var tio_shop_bubble_time_modificator : float = 1.5
#var tio_maximum_bubbles : int = 10
var wind_speed : float = 100.0

var global_bubble_index : int = 0
var global_bubble_count : int = 0
var global_bubble_modificator : int = 1
