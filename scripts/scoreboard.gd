
extends Node2D

onready var scoreboard = global.local_scoreboard

func _ready():
	print(scoreboard)
	for i in range(scoreboard.size()):
		get_node("HBoxContainer/VBoxContainer").get_child(i+1).set_text(scoreboard[i][0])
		get_node("HBoxContainer/VBoxContainer1").get_child(i+1).set_text(str(scoreboard[i][1]))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		global.goto_scene("res://scenes/main_menu.tscn")
