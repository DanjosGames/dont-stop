extends Node

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY && event.scancode == KEY_F1 && event.is_pressed() && !event.is_echo():
		OS.set_window_fullscreen(!OS.is_window_fullscreen())