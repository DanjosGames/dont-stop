extends KinematicBody2D

var input_states = preload("res://scripts/input_state.gd")

const MOVE_SPEED = 500
const GRAVITY = 900
const JUMP_HEIGHT = -800
const STATE_GROUND = 0
const STATE_JUMP = 1
const MAX_JUMP_TIME = 0.35

var can_jump = true
var jump_time = 0
var jump = input_states.new("jump")
var btn_jump = null

var current_state = STATE_GROUND
var next_state = STATE_GROUND
var current_score = 0
var vel = Vector2()

signal player_stopped

onready var ray = get_node("RayCast2D")
onready var cam = get_parent().get_node("Camera2D")
onready var sample_player = get_node("SamplePlayer")

func _ready():
	ray.add_exception(self)

func _jump_state(delta):
	jump_time += delta
	if btn_jump == 2 and not jump_time >= MAX_JUMP_TIME:
		vel.y = JUMP_HEIGHT
	else:
		can_jump = false

func _ground_state(delta):
	if ray.is_colliding():
		vel.y = 0
		jump_time = 0
		can_jump = true
	else:
		vel.y = GRAVITY

func _fixed_process(delta):
	btn_jump = jump.check()
	current_state = next_state
	vel.x = MOVE_SPEED

	if can_jump && btn_jump in [1, 2]:
		next_state = STATE_JUMP
	else:
		next_state = STATE_GROUND
	if current_state == STATE_JUMP:
		_jump_state(delta)
	elif current_state == STATE_GROUND:
		_ground_state(delta)
	move(vel*delta)
	if get_travel().x > 0:
		current_score += get_travel().x/100
		cam.move(get_travel())

func die():
	set_fixed_process(false)
	emit_signal("player_stopped")
