extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shopping_cart_button_up():
	%Control.visible = true;


func _on_close_button_button_up():
	%Control.visible = false;
