extends Control

@onready var UPGRADE = preload("res://ui_shop/upgrade.tscn")
@onready var shopping = preload("res://resources/shopping_cart.png");
@onready var shopping_active = preload("res://resources/shopping_cart(1).png");

func _ready():
	BubblesGlobal.bubbles_updated.connect(_on_bubbles_updated);
	for upgrade in BubblesGlobal.upgrades:
		var control = UPGRADE.instantiate();
		control.upgrade_name = upgrade.name;
		control.upgrade_price = upgrade.prices[0];
		control.upgrade_quantity = upgrade.quantity;
		if (ResourceLoader.exists("res://resources/" + upgrade.img)):
			control.upgrade_img = ResourceLoader.load("res://resources/" + upgrade.img);
		$Upgrades/Wrapper.add_child(control);

func _on_shopping_cart_button_up():
	$Upgrades.visible = true;
	$ShoppingCart.visible = false;

func _on_close_button_button_up():
	$Upgrades.visible = false;
	$ShoppingCart.visible = true;

func _on_bubbles_updated():
	for upgrade in $Upgrades/Wrapper.get_children():
		if (upgrade.upgrade_price != "-1" && BubblesGlobal.compare(upgrade.upgrade_price)):
			$ShoppingCart.texture_normal = shopping_active;
			return;
	$ShoppingCart.texture_normal = shopping;
