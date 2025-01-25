extends HBoxContainer

var upgrade_name: String;
var upgrade_price: String;
var upgrade_quantity: int;
var upgrade_img: CompressedTexture2D;

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
		$Value/Price.text = upgrade_price;

func _on_buy_pressed():
	if (BubblesGlobal.compare(upgrade_price)):
		BubblesGlobal.upgrade_purchased.emit(upgrade_name);
		BubblesGlobal.subtractBubbles(upgrade_price);
		upgrade_quantity += 1;
		upgrade_price = upgradePrice();
		_setValues();

func upgradePrice():
	var upgrade = BubblesGlobal.upgrades.filter(func (upgrade): return upgrade.name == upgrade_name);
	if (upgrade[0].price.length() > 0):
		return addPrice(upgrade_price);
	else:
		var i = 0;
		while i < upgrade[0].prices.size() && upgrade[0].prices[i] != upgrade_price:
			i += 1;
		if (i  < upgrade[0].prices.size() - 1):
			return upgrade[0].prices[i + 1];
		return "-1";

func addPrice(num : String):
	var numArr = BubblesGlobal.arrayBubbles(num);
	var priceArr = BubblesGlobal.arrayBubbles(upgrade_price);
	var result = [];
	var carry = 0;
 
	while numArr.size() > 0 or priceArr.size() > 0:
		var sum = 0;
 
		if numArr.size() > 0:
			sum += numArr.pop_front();
 
		if priceArr.size() > 0:
			sum += priceArr.pop_front();
 
		sum += carry;
		carry = 0;
 
		result.append(BubblesGlobal.arrayBubbles(str(sum))[0]);
 
		if BubblesGlobal.arrayBubbles(str(sum)).size() > 1:
			carry = BubblesGlobal.arrayBubbles(str(sum))[1];
 
	if carry != 0:
		result.append(carry);
 
	return BubblesGlobal.displayBubbles(result);
