extends Node2D
#
#const VU_COUNT = 16
#const FREQ_MAX = 11050.0
#
#const WIDTH = 400
#const HEIGHT = 100
#
#const MIN_DB = 60
#
#var spectrum
#var polyStreamPlayer
#
#var vocal_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Vocal.mp3")
#var drum_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Drum.mp3")
#var other_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Other.mp3")
#var piano_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Piano.mp3")
#var bass_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Bass.mp3")
#
#func _ready():
	#spectrum = AudioServer.get_bus_effect_instance(0,0)
	##vocal = AudioServer.get_bus_effect_instance(1,0)
	##other = AudioServer.get_bus_effect_instance(2,0)
	#polyStreamPlayer = get_node("AudioStreamPlayer")
#
#func _process(_delta):
	#queue_redraw()
#
#
#func _draw():
	##warning-ignore:integer_division
	#var w = WIDTH / VU_COUNT
	#var prev_hz = 0
	#var colors = [Color.WHITE, ]
	#for i in range(1, VU_COUNT+1):
		#var hz = i * FREQ_MAX / VU_COUNT;
		#var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		#var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		#var height = energy * HEIGHT
		#draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.WHITE)
		#prev_hz = hz
