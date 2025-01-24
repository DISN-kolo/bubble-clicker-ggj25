extends Control

const NOTATION : Array = ['','K','M','B','T','Qa','Qi','Sx','Sp','Oc']

var passive: String = "100";

var bubbles_value: Array = []:
	set(value):
		bubbles_value = value;
		%Label.text = str(bubbles_value[bubbles_value.size() -1]) + NOTATION[bubbles_value.size() -1];

func _ready():
	bubbles_value = arrayBubbles("0");

func displayBubbles():
	var tmp = bubbles_value.duplicate();
	var nStr = "";
	
	while tmp:
		nStr += str(tmp.pop_back()).pad_zeros(3);
	
	for i in range(nStr.length()):
		if nStr[i] != '0':
			nStr = nStr.substr(i,-1)
			break;
	return nStr;

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
 
	bubbles_value = result;

func addBubbles(num: String):
	add(arrayBubbles(num));
	
func subtractBubbles(num: String):
	subtract(arrayBubbles(num));

func _on_timer_timeout():
	add(arrayBubbles(passive));
