extends Node

signal bubbles_updated;
signal upgrade_purchased;

const NOTATION : Array = ['','K','M','B','T','Qa','Qi','Sx','Sp','Oc']

const upgrades = [
	{
		"name": "Bubble guy",
		"quantity": 1,
		"img": "UpTio.png",
		"price" : "",
		"prices": ["1", "2", "4", "8", "16", "32", "64", "128", "256", "512", "1024", "2048", "4096", "8192", "24576", "40960"],
		"noLimit": true
	},
	{
		"name": "Fun shop",
		"quantity": 0,
		"img": "UpShoppy.png",
		"prices": ["50", "500", "50000", "500000", "50000000", "5000000000"],
	},
	{
		"name": "Acid factory",
		"quantity": 0,
		"img": "UpFactory.png",
		"prices": ["1000", "10000", "100000", "10000000"],
	},
	{
		"name": "Bubble x2",
		"quantity": 1,
		"img": "UpBubblePtsALTERNATIVE.png",
		"prices": ["10", "100", "500", "2500", "10000", "50000", "1000000"],
	},
	{
		"name": "Reduce wait",
		"quantity": 0,
		"img": "BubbleTimerReduce.png",
		"prices": ["10", "100", "500", "2500", "10000", "50000", "1000000"],
	},
	{
		"name": "Random pops",
		"quantity": 0,
		"img": "UpRandomPop.png",
		"prices": ["10", "100", "500", "2500", "10000", "50000", "1000000"],
	},
		{
		"name": "Auto bath",
		"quantity": 0,
		"img": "UpBath.png",
		"prices": ["10", "100", "500", "2500", "10000", "50000", "1000000"],
	},
]

var bubbles_value: Array = []:
	set(value):
		bubbles_value = value;
		bubbles_updated.emit();

var passive: String = "0";

var multiplier: int = 1;

func _ready():
	bubbles_value = arrayBubbles("0");

func arrayBubbles(num: String):
	var arr = [];
	
	while num != "":
		if num.length() < 3:
			arr.append(int (num));
			break;
		arr.append(int (num.substr(num.length() - 3, 3)));
		num = num.substr(0, num.length() - 3);
	return arr;
	
func add(num : Array):
	var result = [];
	var carry = 0;
 
	while num.size() > 0 or bubbles_value.size() > 0:
		var sum = 0;
 
		if num.size() > 0:
			sum += num.pop_front();
 
		if bubbles_value.size() > 0:
			sum += bubbles_value.pop_front();
 
		sum += carry;
		carry = 0;
 
		result.append(arrayBubbles(str(sum))[0]);
 
		if arrayBubbles(str(sum)).size() > 1:
			carry = arrayBubbles(str(sum))[1];
 
	if carry != 0:
		result.append(carry);
 
	bubbles_value = result;
	
func subtract(num):
	var result = [];
	var borrow = 0;
 
	while num.size() > 0 or bubbles_value.size() > 0:
		var diff= 0;
 
		if bubbles_value.size() > 0:
			diff += bubbles_value.pop_front();
 
		if num.size() > 0:
			diff -= num.pop_front();
 
		diff -= borrow;
 
		if diff < 0:
			diff += 1000;
			borrow = 1;
		else:
			borrow = 0;
		
		result.append(arrayBubbles(str(diff))[0]);
	if (result.size() > 0 && result[result.size() - 1] == 0):
		result.pop_back();
	bubbles_value = result;

func compare(num: String):
	var numStr = displayBubbles(bubbles_value);
	var i = 0;
	
	num = num.pad_zeros(3);
	numStr = numStr.pad_zeros(3);
	if (num.length() != numStr.length()):
		return num.length() < numStr.length();
	while i < numStr.length():
		if (num[i] != numStr[i]):
			return num[i] < numStr[i];
		i += 1;
	return true;

func addBubbles(num: String):
	add(arrayBubbles(num));
	
func subtractBubbles(num: String):
	subtract(arrayBubbles(num));

func displayBubbles(num: Array):
	var tmp = num.duplicate();
	var nStr = "";
	
	while tmp:
		nStr += str(tmp.pop_back()).pad_zeros(3);
	
	for i in range(nStr.length()):
		if nStr[i] != '0':
			nStr = nStr.substr(i,-1)
			break;
	return nStr;
