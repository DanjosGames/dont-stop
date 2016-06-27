extends Camera2D

func move(vel):
	vel.y = 0
	var npos = get_pos()+vel
	set_pos(npos)
