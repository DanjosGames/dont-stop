
extends Panel

var vol = 100

func _ready():
	get_node("Volume/Lower").grab_focus()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		global.goto_scene("res://scenes/main_menu.tscn")

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
