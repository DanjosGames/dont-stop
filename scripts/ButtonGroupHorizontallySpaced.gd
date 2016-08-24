tool
extends ButtonGroup

export(bool) var Horizontal
export(int) var Horizontal_Spacing

func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	update()

func _draw():
	if Horizontal:
		var counter = 0
		for button in get_children():
			button.set_pos(Vector2((button.get_size().width+Horizontal_Spacing) * counter, 0))
			button.set_size(Vector2(button.get_size().width, button.get_size().height))
			counter +=1


