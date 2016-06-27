extends Node2D

signal next_section

func _on_VisibilityNotifier2D_enter_screen():
	emit_signal("next_section")
