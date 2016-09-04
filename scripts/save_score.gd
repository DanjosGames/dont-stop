
extends Control

var valid_chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " "]

onready var name_input = get_node("VBoxContainer/HBoxContainer/name")
onready var score_val = get_node("VBoxContainer/HBoxContainer 2/score")

func _ready():
	score_val.set_text(str(global.current_run_score))
	name_input.grab_focus()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		global.player_name = name_input.get_text()
		global.save_highscore()
		global.goto_scene("res://scenes/main_menu.tscn")
