
extends Node2D

var section_scenes = {
	0 : preload("res://scenes/section.tscn"),
	1 : preload("res://scenes/section_01.tscn"),
	2 : preload("res://scenes/section_01b.tscn"),
	3 : preload("res://scenes/section_02.tscn"),
	4 : preload("res://scenes/section_02b.tscn"),
	5 : preload("res://scenes/section_03.tscn"),
#	6 : preload("res://scenes/section_04.tscn"),
}
onready var current_section = get_child(1)

func _ready():
	current_section.connect("next_section", self, "_on_next_section", [], CONNECT_ONESHOT)

func _on_next_section():
	print("_on_next_section")
	var new_section = section_scenes[randi()%6].instance()
#	var new_section = section_scenes[6].instance()
	new_section.set_pos(Vector2(current_section.get_pos().x+1280, current_section.get_pos().y))
	if current_section.is_connected("next_section", self, "_on_next_section"):
		current_section.disconnect("next_section", self, "_on_next_section")
	new_section.connect("next_section", self, "_on_next_section", [], CONNECT_ONESHOT)
	current_section = new_section
	add_child(new_section)
	if get_child_count() > 4:
		remove_child(get_child(0))
