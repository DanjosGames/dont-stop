extends Node2D

const STATE_START = 0
const STATE_RUNNING = 1
const STATE_STOP = 2

var current_state = STATE_START

onready var player = get_node("player")
onready var game_over = get_node("Camera2D/game_over")
onready var get_ready = get_node("Camera2D/get_ready")
onready var retry = get_node("Camera2D/retry")

func _ready():
	player.connect("player_stopped", self, "_on_player_stopped")
	get_node("Camera2D/get_ready/AnimationPlayer").connect("finished", self, "_on_countdown_finished")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump"):
		if current_state == STATE_START:
			current_state = STATE_RUNNING
			get_node("Camera2D/get_ready/AnimationPlayer").play("go")
		elif current_state == STATE_STOP:
			if global.player_lives > 0:
				global.goto_scene("res://scenes/game.tscn")
			else:
				global.save_highscore()
				global.goto_scene("res://scenes/main_menu.tscn")
	elif event.type == InputEvent.KEY && event.scancode == KEY_ESCAPE && event.is_pressed() && !event.is_echo():
		global.goto_scene("res://scenes/main.tscn")

func _on_countdown_finished():
	get_node("Camera2D/get_ready").hide()
	player.set_fixed_process(true)

func _on_player_stopped():
	global.player_lives -= 1
	global.current_run_score += int(player.current_score)
	if int(player.current_score) > global.current_run_highscore:
		global.current_run_highscore = int(player.current_score)
	if global.player_lives < 1:
		game_over.show()
	else:
		retry.get_node("text").set_text("retry? (" + str(global.player_lives) + " left)")
		retry.show()
	current_state = STATE_STOP