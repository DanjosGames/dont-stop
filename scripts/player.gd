extends KinematicBody2D

const MOVE_SPEED = 450
const GRAVITY = 30
const JUMP_HEIGHT = -800

var current_score = 0
var vel = Vector2()

signal player_stopped

onready var ray = get_node("RayCast2D")
onready var cam = get_parent().get_node("Camera2D")
onready var sample_player = get_node("SamplePlayer")

func _ready():
	ray.add_exception(self)

func _fixed_process(delta):
	if ray.is_colliding():
		vel.y = 0
		if Input.is_action_pressed("jump"):
			sample_player.play("jump")
			vel.y = JUMP_HEIGHT
	else:
		vel.y += GRAVITY
	vel.x = MOVE_SPEED
	move(vel*delta)
	if get_travel().x > 0:
		current_score += get_travel().x/100
		cam.move(get_travel())

func die():
	set_fixed_process(false)
	emit_signal("player_stopped")
