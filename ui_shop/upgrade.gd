extends HBoxContainer

var upgrade_name: String;
var upgrade_price: String;
var upgrade_quantity: int;
var upgrade_img: CompressedTexture2D;

@onready var audio_player = $AudioStreamPlayer2D
var rng = RandomNumberGenerator.new()

func _ready():
	_setValues();

func _setValues():
	$Item/Img.texture = upgrade_img;
	$Item/Name.text = upgrade_name;
	$Item/Quantity.text = str(upgrade_quantity);
	if (upgrade_price == "-1"):
		$Value/Price.text = "MAX";
		$Value/Img.visible = false;
		$Value/Buy.visible = false;
	else:
		var values = BubblesGlobal.arrayBubbles(upgrade_price);
		var size = values.size() - 1;
		var price: String;
		if (size > 0 && values[size - 1] != 0):
			price = str(values[size]) + "." + str(values[size - 1]).pad_zeros(3) + BubblesGlobal.NOTATION[size];	
		else:
			price = str(values[size]) + BubblesGlobal.NOTATION[size];
		$Value/Price.text = price;

func _on_buy_pressed():
	var old_price: String;
	if (BubblesGlobal.compare(upgrade_price)):
		old_price = upgrade_price;
		BubblesGlobal.upgrade_purchased.emit(upgrade_name);
		upgrade_quantity += 1;
		upgrade_price = upgradePrice();
		_setValues();
		BubblesGlobal.subtractBubbles(old_price);
		audio_player.pitch_scale = rng.randf_range(0.98, 1.02)
		audio_player.play()

func upgradePrice():
	var upgrade = BubblesGlobal.upgrades.filter(func (upgrade): return upgrade.name == upgrade_name);
	var i = 0;
	while i < upgrade[0].prices.size() && upgrade[0].prices[i] != upgrade_price:
		i += 1;
	if (i  < upgrade[0].prices.size() - 1):
		return upgrade[0].prices[i + 1];
	elif (upgrade[0].noLimit):
		return upgrade_price;
	return "-1";
