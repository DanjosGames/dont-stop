extends Node2D

var loader
var wait_frames
var time_max = 100 # msec
var current_scene = null
var config_file = null
var config = {}
var player_lives = 10
var current_run_score = 0
var current_run_highscore = 0
var local_scoreboard = []

func _ready():
	_read_config()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func _read_config():
	config_file = ConfigFile.new()
	config_file.load("user://file0")
	config["progress/highscore"] = config_file.get_value("progress", "highscore", 0)
	config["progress/best_run"] = config_file.get_value("progress", "best_run", 0)
	config["settings/volume"] = config_file.get_value("settings", "volume", 100)
	AudioServer.set_fx_global_volume_scale(config["settings/volume"]/100.0)
	AudioServer.set_stream_global_volume_scale(config["settings/volume"]/100.0)

func _save_config():
	config_file = ConfigFile.new()
	config_file.load("user://file0")
	for key in config.keys():
		config_file.set_value(key.split("/")[0], key.split("/")[1], config[key])
	config_file.save("user://file0")

func save_highscore():
	if current_run_highscore > config["progress/highscore"]:
		config["progress/highscore"] = current_run_highscore
	if current_run_highscore > config["progress/best_run"]:
		config["progress/best_run"] = current_run_score
	_save_config()

func sort_scoreboard(a, b):
	return a[1] > b[1]

func get_highscore():
	return config["progress/highscore"]

func get_settings():
	return {"volume" : config["settings/volume"]}

func save_settings(new_settings):
	for key in new_settings.keys():
		config["settings/"+key] = new_settings[key]
	_save_config()

func reset_run():
	player_lives = 10
	current_run_highscore = 0
	current_run_score = 0

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