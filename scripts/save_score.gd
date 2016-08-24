
extends CanvasLayer

var valid_chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " "]

onready var buttongroup = get_node("name_label/ButtonGroup")
onready var score_val = get_node("score_label/Label")

func _ready():
	score_val.set_text(str(global.current_run_score))
	buttongroup.get_child(0).grab_focus()
	print(str(buttongroup.get_focused_button()))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_up"):
		var btn = buttongroup.get_focused_button()
		var char_i = valid_chars.find(btn.get_text())
		btn.set_text(valid_chars[char_i - 1])
	if event.is_action_pressed("ui_down"):
		var btn = buttongroup.get_focused_button()
		var char_i = valid_chars.find(btn.get_text())
		if char_i == valid_chars.size()-1:
			char_i = -1
		print(char_i)
		btn.set_text(valid_chars[char_i + 1])
	if event.is_action_pressed("ui_accept"):
		global.save_highscore()
		global.goto_scene("res://scenes/main_menu.tscn")
