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
var asp_last_seek = 0.0;
var current_program_song_id = 0

# ToDo: Connect UI signals to functions in this script that update these variables
var freq_min: float = 100.0
var freq_max: float = 15000.0
var min_db: float = 60.0
var bins_per_spec: int = 256
var height_scale: float = 1.0

# ToDo: UI signal should pass an array of bus names for the 

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
	

func _input(event):

	if event is InputEventKey:
		match event.keycode:
			KEY_I:
				for asp in audio_stream_players:
					asp.stop()
				current_program_song_id = (current_program_song_id + 1) % Global.PROGRAM_SONGS.size()
				_load_program_song(current_program_song_id)
				for asp in audio_stream_players:
					asp.play()
	
				print("Playing ", Global.PROGRAM_SONGS[current_program_song_id])



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
	
	# Update shader uniform
	# print first 10 values of first spectrum
	# print(spectrums[0], spectrums[1], spectrums[2], spectrums[3], spectrums[4], spectrums[5], spectrums[6], spectrums[7], spectrums[8], spectrums[9])
	material.set_shader_parameter("bins", spectrums)



func _on_ui_canvas_toggle_stem(toggled_on:Variant, stem_ID:Variant):
	material.set_shader_parameter("toggled_on", toggled_on)
	print("Toggled on: ", toggled_on, " Stem ID: ", stem_ID)


func _on_ui_canvas_toggle_playstop(toggled_on:Variant):

	for asp in audio_stream_players:
		asp.stream_paused = not toggled_on


	# Get current position of first audio stream player
	# var current_position = audio_stream_players[0].get_playback_position()

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
		_:
			print("Invalid slider ID: ", slider_ID)
			return
