extends Control

const NOTATION : Array = ['','K','M','B','T','Qa','Qi','Sx','Sp','Oc']

func _ready():
	BubblesGlobal.bubbles_updated.connect(on_bubbles_update);
	
func on_bubbles_update():
	var size = BubblesGlobal.bubbles_value.size() - 1;
	%Label.text = str(BubblesGlobal.bubbles_value[size]) + NOTATION[size];

func _on_timer_timeout():
	if BubblesGlobal.passive != "0":
		BubblesGlobal.addBubbles(BubblesGlobal.passive);
