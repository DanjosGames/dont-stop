extends Node2D

const STATE_START = 0
const STATE_RUNNING = 1
const STATE_STOP = 2

var current_state = STATE_START

onready var player = get_node("player")
onready var game_over = get_node("Camera2D/game_over")

func _ready():
	player.connect("player_stopped", self, "_on_player_stopped")
	get_node("Camera2D/get_ready/AnimationPlayer").connect("finished", self, "_on_countdown_finished")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("jump"):
		if current_state == STATE_START:
			current_state = STATE_RUNNING
			get_node("Camera2D/get_ready/AnimationPlayer").play("countdown")
		elif current_state == STATE_STOP:
			global.goto_scene("res://scenes/game.tscn")
	elif event.type == InputEvent.KEY && event.scancode == KEY_ESCAPE && event.is_pressed() && !event.is_echo():
		global.goto_scene("res://scenes/main.tscn")

func _on_countdown_finished():
	get_node("Camera2D/get_ready").hide()
	player.set_fixed_process(true)

func _on_player_stopped():
	game_over.show()
	current_state = STATE_STOP
	if int(player.current_score) > global.highscore:
		global.save_highscore(int(player.current_score))
