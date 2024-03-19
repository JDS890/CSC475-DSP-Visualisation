extends Node2D

var spectrum
var polyStreamPlayer

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(3,0)
	#vocal = AudioServer.get_bus_effect_instance(1,0)
	#other = AudioServer.get_bus_effect_instance(2,0)
	#polyStreamPlayer = get_node("AudioStreamPlayer")

func _process(_delta):
	queue_redraw()

func _draw():
	#warning-ignore:integer_division
	var w = Global.WIDTH / Global.VU_COUNT
	var prev_hz = 0
	var colors = [Color.WHITE, ]
	for i in range(1, Global.VU_COUNT+1):
		var hz = i * Global.FREQ_MAX / Global.VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((Global.MIN_DB + linear_to_db(magnitude)) / Global.MIN_DB, 0, 1)
		var height = energy * Global.HEIGHT
		draw_rect(Rect2(w * i, Global.HEIGHT - height + 300, w, height), Global.STREAM_COLORS[1])
		prev_hz = hz
