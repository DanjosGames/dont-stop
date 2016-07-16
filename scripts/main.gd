extends Control

var delta_counter = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("bg/hScoreLabel/hscore").set_text(str(global.highscore))
	get_node("run").grab_focus()
	randomize()
	set_process(true)

func _process(delta):
	delta_counter += delta
	if delta_counter >= 5:
		delta_counter = 0
		var rf = randf()
		print(str(rf))
		if rf < 0.1 and get_node("bg/title_anim").get_current_animation() == "title_anim_dist2":
			get_node("bg/title_anim").play("title_anim")
			get_node("bg/title_anim").queue("title_anim_dist2")
	else:
		var rf = randf()
		if rf < 0.01 and get_node("bg/title_anim").get_current_animation() == "title_anim_dist2":
			get_node("bg/title_anim").play("title_anim_dist1")
			get_node("bg/title_anim").queue("title_anim_dist2")


func _on_run_pressed():
	global.goto_scene("res://scenes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_focus_exit():
	get_node("SamplePlayer").play("menu_focus")
