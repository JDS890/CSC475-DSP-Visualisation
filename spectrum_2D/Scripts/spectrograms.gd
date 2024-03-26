extends Node3D

# @export var bus_names_init: Array = ["Original Bus", "Bass Bus", "Drum Bus", "Fusion Bus", "Piano Bus"]
@export var bus_names_init: Array = ["Original Bus"]

@export var bass_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow - Bass.mp3"
@export var drums_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow - Drum.mp3"
@export var other_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow - Other.mp3"
@export var piano_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow - Piano.mp3"
@export var vocal_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow - Vocal.mp3"
@export var original_mp3_path: String = "res://Audio Samples/Like a Shadow/Like a Shadow.mp3"

const SPEC_MAX: int = 5
const BINS_PER_SPEC_MAX: int = 256

var spectrum_analyzer_effects: Array = []
var spectrums: PackedFloat32Array = PackedFloat32Array()
var material: Material = null

# ToDo: Connect UI signals to functions in this script that update these variables
var freq_min: float = 100.0
var freq_max: float = 15000.0
var min_db: float = 60.0
var bins_per_spec: int = 256
var height_scale: float = 1.0


# ToDo: UI signal should pass an array of bus names for the 

func _add_audio_stream_players():
	# bass, vocal, drums, piano, other, fusion, original
	var bus_names = ["Bass Bus", "Vocal Bus", "Drum Bus", "Piano Bus", "Other Bus", "Fusion Bus", "Original Bus"]
	

func _set_ae_instances(bus_names: Array):
	# clear array
	for i in range(min(bus_names.size(), SPEC_MAX)):
		spectrum_analyzer_effects.append(AudioServer.get_bus_effect_instance( AudioServer.get_bus_index(bus_names[i]), 0 ))
	spectrums.fill(0.0)

func _ready():
	spectrums.resize(BINS_PER_SPEC_MAX * SPEC_MAX)
	_set_ae_instances(bus_names_init)
	material = get_node("S1").get_child(0).get_surface_override_material(0)
	


func _process(_delta):

	for j in range(spectrum_analyzer_effects.size()):

		var freq_prev = freq_min
		var spectrum = spectrum_analyzer_effects[j]
		var freq_step = (freq_max - freq_min) / bins_per_spec

		for i in range(bins_per_spec):
			var freq = (i + 1) * freq_step + freq_min
			var magnitude = spectrum.get_magnitude_for_frequency_range(freq_prev, freq).length()
			var energy = clamp((min_db + linear_to_db(magnitude)) / min_db, 0, 1)
			spectrums[(j << 8) + i] = energy
			freq_prev = freq
	
	# Update shader uniform
	material.set_shader_parameter("bins", spectrums)

