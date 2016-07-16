extends Node2D

var loader
var wait_frames
var time_max = 100 # msec
var current_scene = null

var highscore_file = null
var highscore = 0

func _ready():
	read_highscore()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func save_highscore(new_highscore):
	highscore = new_highscore
	highscore_file = File.new()
	highscore_file.open("user://highscore", highscore_file.WRITE)
	highscore_file.store_var(highscore)
	highscore_file.close()
	highscore_file = null

func read_highscore():
	highscore_file = File.new()
	if highscore_file.file_exists("user://highscore"):
		highscore_file.open("user://highscore", highscore_file.READ)
		highscore = highscore_file.get_var()
		highscore_file.close()
		highscore_file = null
	else:
		highscore = 0

func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	show()
	get_node("animation").play("loading")
	wait_frames = 10

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	# wait for frames to let the "loading" animation to show up
	if wait_frames > 0:
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	# use "time_max" to control how much time we block this thread
	while OS.get_ticks_msec() < t + time_max:
		# poll your loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	var len = get_node("animation").get_current_animation_length()
	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
	hide()
	get_node("animation").stop()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)