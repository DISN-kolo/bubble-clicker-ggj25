extends Control

func _ready():
	BubblesGlobal.bubbles_updated.connect(on_bubbles_update);
	
func on_bubbles_update():
	var size = BubblesGlobal.bubbles_value.size() - 1;
	var bubbles: String;
	
	if (size > 0 && BubblesGlobal.bubbles_value[size - 1] != 0):
		bubbles = str(BubblesGlobal.bubbles_value[size]) + "." + str(BubblesGlobal.bubbles_value[size - 1]).pad_zeros(3) + BubblesGlobal.NOTATION[size];	
	elif (size >= 0):
		bubbles = str(BubblesGlobal.bubbles_value[size]) + BubblesGlobal.NOTATION[size];
	else:
		bubbles = "0";
	$Label.text = bubbles;
	
func _on_timer_timeout():
	if BubblesGlobal.passive != "0":
		BubblesGlobal.addBubbles(BubblesGlobal.passive);
