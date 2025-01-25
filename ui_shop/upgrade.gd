extends HBoxContainer

@export var upgrade_name: String;
@export var upgrade_price: String;
@export var upgrade_quantity: int;
@export var upgrade_img: CompressedTexture2D;

func _ready():
	_setValues();

func _setValues():
	$Item/Img.texture = upgrade_img;
	$Item/Name.text = upgrade_name;
	$Price/Num.text = upgrade_price;
	$Value/Quantity.text = str(upgrade_quantity);

func _on_buy_pressed():
	if (BubblesGlobal.compare(upgrade_price)):
		BubblesGlobal.upgrade_purchased.emit(upgrade_name);
		BubblesGlobal.subtractBubbles(upgrade_price);
		upgrade_quantity += 1;
		_setValues();
