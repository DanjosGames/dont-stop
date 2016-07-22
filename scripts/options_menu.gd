
extends Panel

var vol = 100

func _ready():
	get_node("Volume/Lower").grab_focus()

func _on_Lower_pressed():
	vol -= 1
	if vol < 0:
		vol = 0
	get_node("Volume/Value").set_text(str(vol))

func _on_Raise_pressed():
	vol += 1
	if vol > 100:
		vol = 100
	get_node("Volume/Value").set_text(str(vol))
