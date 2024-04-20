extends Node3D

const SPEC_MAX: int = 5
const BINS_PER_SPEC_MAX: int = 256
const STEMBUS_NAMES = [
	&"Bass Bus",
	&"Drum Bus",
	&"Other Bus",
	&"Piano Bus",
	&"Vocal Bus",
]

var spectrum_analyzers: Array = []
var spectrums: PackedFloat32Array = PackedFloat32Array()
var material: Material = null
var audio_stream_players: Array = []
var asp_last_seek = 0.0
var current_program_song_id = 4 # Like a Shadow

var spec_mode: int = Global.SPEC_MODE_DEFAULT
var freq_min: float = Global.FREQ_MIN_DEFAULT
var freq_max: float = Global.FREQ_MAX_DEFAULT
var min_db: float = Global.MIN_DB_DEFAULT
var bins_per_spec: int = Global.BINS_PER_SPEC_DEFAULT
var stem_height_scales = Global.STEM_HEIGHT_SCALES_DEFAULT
var stem_height_toggles = [1.0, 1.0, 1.0, 1.0, 1.0]


func _load_program_song(program_song_id):
	if program_song_id not in range(Global.PROGRAM_SONGS.size()):
		print("Invalid program song ID: ", program_song_id)
		return
	
	var song_stems = Global.get_all_program_song_paths(Global.PROGRAM_SONGS[program_song_id])
	for i in range(song_stems.size()):
		audio_stream_players[i].stream = load(song_stems[i])
		audio_stream_players[i].autoplay = false
		audio_stream_players[i].playing = false
		audio_stream_players[i].stream_paused = false
		audio_stream_players[i].volume_db = 0.0
		print("Loaded stem: ", song_stems[i])
		asp_last_seek = 0.0


func _create_audio_stream_players():
	for i in range(STEMBUS_NAMES.size()):
		var asp = AudioStreamPlayer.new()
		asp.bus = STEMBUS_NAMES[i]
		asp.volume_db = 0.0
		asp.autoplay = false
		asp.playing = false
		asp.stream_paused = false
		audio_stream_players.append(asp)
		add_child(asp)


func _gather_spectrum_analyzer_instances():
	spectrum_analyzers.clear()
	for stem_bus in STEMBUS_NAMES:
		spectrum_analyzers.append( AudioServer.get_bus_effect_instance( AudioServer.get_bus_index(stem_bus), 0 ))
	spectrums.fill(0.0)


func _ready():

	spectrums.resize(BINS_PER_SPEC_MAX * SPEC_MAX)
	material = get_node("S1").get_child(0).get_surface_override_material(0)

	_gather_spectrum_analyzer_instances()
	_create_audio_stream_players()
	_load_program_song(current_program_song_id)
	for asp in audio_stream_players:
		asp.play()
	
	material.set_shader_parameter("bins_per_spec", bins_per_spec)
	material.set_shader_parameter("spec_scale", Global.HEIGHT_SCALE_DEFAULT)
	material.set_shader_parameter("bin_width", Global.BIN_WIDTH_DEFAULT)
	material.set_shader_parameter("spec_separation", Global.SPEC_SEPARATION_DEFAULT)
	material.set_shader_parameter("spec_scales", stem_height_scales)
	material.set_shader_parameter("mode", Global.SPEC_MODE_DEFAULT)
	material.set_shader_parameter("alpha", Global.ALPHA_DEFAULT)

	# $OrthoCam.set_current(true)
	

func _input(_event):
	if Input.is_action_just_pressed("change_song"):
		for asp in audio_stream_players:
			asp.stop()
		current_program_song_id = (current_program_song_id + 1) % Global.PROGRAM_SONGS.size()
		_load_program_song(current_program_song_id)
		for asp in audio_stream_players:
			asp.play()
		print("Playing ", Global.PROGRAM_SONGS[current_program_song_id])
		Global.songname = Global.PROGRAM_SONGS[current_program_song_id]

	elif Input.is_action_just_pressed("change_mode"):
		spec_mode = (spec_mode + 1) % Global.SPECMODES.size()
		material.set_shader_parameter("mode", spec_mode)
		print("change_mode pressed!")
		
	elif Input.is_action_just_pressed("change_camera"):
		
		# Get all children of the $Cameras node
		var cameras = $Cameras.get_children()
		print("Cameras: ", cameras)

		# Find the current camera
		var current_camera = null
		for camera in cameras:
			if camera.is_current():
				current_camera = camera
				break
		
		# Find the next camera
		var next_camera = null
		for i in range(cameras.size()):
			if cameras[i] == current_camera:
				next_camera = cameras[(i + 1) % cameras.size()]
				break
		
		# Set the next camera as current
		if next_camera:
			next_camera.set_current(true)
			print("Switched to camera: ", next_camera.get_name())
		else:
			print("No cameras found!")


		

func _process(_delta):

	for j in range(spectrum_analyzers.size()):

		var freq_prev = freq_min
		var spectrum_analyzer = spectrum_analyzers[j]
		var freq_step = (freq_max - freq_min) / bins_per_spec

		for i in range(bins_per_spec):
			var freq = (i + 1) * freq_step + freq_min
			var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(freq_prev, freq).length()
			var energy = clamp((min_db + linear_to_db(magnitude)) / min_db, 0, 1)
			spectrums[(j << 8) + i] = energy
			freq_prev = freq
	
	material.set_shader_parameter("bins", spectrums)


func _update_scales():
	var stem_height_scales_temp = stem_height_scales.duplicate()
	for i in range(stem_height_scales.size()):
		stem_height_scales_temp[i] *= stem_height_toggles[i]
	material.set_shader_parameter("spec_scales", stem_height_scales_temp)


func _on_ui_canvas_toggle_stem(toggled_on:Variant, stem_ID:Variant, stem_val:Variant):
	print("Toggled on: ", toggled_on, " Stem ID: ", stem_ID)
	if toggled_on:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(STEMBUS_NAMES[stem_ID]), linear_to_db(stem_val))
		stem_height_toggles[stem_ID] = 1.0
		_update_scales()
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(STEMBUS_NAMES[stem_ID]), linear_to_db(0))
		stem_height_toggles[stem_ID] = 0.0
		_update_scales()


func _on_ui_canvas_update_stem(new_val:Variant, stem_ID:Variant):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(STEMBUS_NAMES[stem_ID]), linear_to_db(new_val))
	stem_height_scales[stem_ID] = new_val;
	_update_scales()
	

func _on_ui_canvas_toggle_playstop(toggled_on:Variant):

	for asp in audio_stream_players:
		asp.stream_paused = not toggled_on
	
	if toggled_on:
		material.set_shader_parameter("spec_scales", stem_height_scales)
	else:
		var stem_height_scales_off = [0.0, 0.0, 0.0, 0.0, 0.0]
		material.set_shader_parameter("spec_scales", stem_height_scales_off)





func _on_ui_canvas_update_spectrogram(new_val:Variant, slider_ID:Variant):

# enum UISLIDERS {
# 	BINS = 0,
# 	SCALE = 1,
# 	BIN_WIDTH = 2,
# 	FREQ_MIN = 3,
# 	FREQ_MAX = 4,
# 	MIN_DB = 5,
# 	SEPARATION = 6,
# }

	match slider_ID:

		Global.UISLIDERS.BINS:
			material.set_shader_parameter("bins_per_spec", clamp(new_val, 1, 256))
		
		Global.UISLIDERS.SCALE:
			material.set_shader_parameter("spec_scale", new_val)
		
		Global.UISLIDERS.BIN_WIDTH:
			material.set_shader_parameter("bin_width", new_val)

		Global.UISLIDERS.FREQ_MIN:
			freq_min = new_val
		
		Global.UISLIDERS.FREQ_MAX:
			freq_max = new_val
		
		Global.UISLIDERS.MIN_DB:
			min_db = new_val

		Global.UISLIDERS.SEPARATION:
			material.set_shader_parameter("spec_separation", new_val)
		
		Global.UISLIDERS.ALPHA:
			material.set_shader_parameter("alpha", new_val)
		_:
			print("Invalid slider ID: ", slider_ID)
			return


func _on_ui_canvas_track_seek(track_poz):
	var length = audio_stream_players[0].stream.get_length()
	var seek = length * track_poz / 100.0
	for asp in audio_stream_players:
		asp.seek(seek)

	# for asp in audio_stream_players:
	# 	asp.stop()
	

	# 	asp.seek(length * track_poz)
	# 	asp.play()
	# 	asp.playing = true
	# 	asp.stream_paused = false


	# var current_position = audio_stream_players[0].get_playback_position()

	# get length of first audio stream player

	# if toggled_on:
	# 	for asp in audio_stream_players:
	# 		asp.seek(asp_last_seek)
	# 		asp.play()
	# 		asp.playing = toggled_on
	# 		asp.stream_paused = not toggled_on
	# 		print("Playing: ", asp.playing, " Stream paused: ", asp.stream_paused)
	# else:
	# 	asp_last_seek = current_position
	# 	for asp in audio_stream_players:
	# 		asp.stop()
	# 		asp.playing = toggled_on
	# 		asp.stream_paused = not toggled_on
	# 		print("Playing: ", asp.playing, " Stream paused: ", asp.stream_paused)
