extends Control

@onready var UPGRADE = preload("res://ui_shop/upgrade.tscn")

func _ready():
	for upgrade in BubblesGlobal.upgrades:
		var control = UPGRADE.instantiate();
		control.upgrade_name = upgrade.name;
		control.upgrade_price = upgrade.price;
		control.upgrade_quantity = upgrade.quantity;
		if (ResourceLoader.exists("res://resources/" + upgrade.img)):
			control.upgrade_img = ResourceLoader.load("res://resources/" + upgrade.img);
		$Control/Upgrades.add_child(control);

func _on_shopping_cart_button_up():
	%Control.visible = true;

func _on_close_button_button_up():
	%Control.visible = false;
