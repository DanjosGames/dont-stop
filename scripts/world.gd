
extends Node2D

var section_scenes = {
#	0 : preload("res://scenes/section.tscn"),
	0 : preload("res://scenes/section_01.tscn"),
	1 : preload("res://scenes/section_01b.tscn"),
	2 : preload("res://scenes/section_02.tscn"),
	3 : preload("res://scenes/section_02b.tscn"),
	4 : preload("res://scenes/section_03.tscn"),
#	6 : preload("res://scenes/section_04.tscn"),
}

var sections = _shuffleList([0, 1, 2, 3, 4])

onready var current_section = get_child(1)

func _ready():
	current_section.connect("next_section", self, "_on_next_section", [], CONNECT_ONESHOT)

func _shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        randomize()
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList

func _get_next_section():
	if sections.empty():
		sections = _shuffleList([0, 1, 2, 3, 4])
	var next_section = section_scenes[sections[0]]
	sections.pop_front()
	return next_section

func _on_next_section():
	var new_section = _get_next_section().instance()
	new_section.set_pos(Vector2(current_section.get_pos().x+1280, current_section.get_pos().y))
	if current_section.is_connected("next_section", self, "_on_next_section"):
		current_section.disconnect("next_section", self, "_on_next_section")
	new_section.connect("next_section", self, "_on_next_section", [], CONNECT_ONESHOT)
	current_section = new_section
	add_child(new_section)
	if get_child_count() > 4:
		remove_child(get_child(0))
