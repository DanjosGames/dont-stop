extends Control

var player = null
export(NodePath) var playerNode

func _ready():
	player = get_node(playerNode)
	set_process(true)

func _process(delta):
	get_node("score").set_text(str(int(player.current_score)))
	get_node("total").set_text(str(int(global.current_run_score)))
