extends Node2D

#var vocal
var spectrum

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(
		AudioServer.get_bus_index("Piano Bus"),
		0
	)

func _process(_delta):
	queue_redraw()

func _draw():
	#warning-ignore:integer_division
	var w = Global.WIDTH / Global.vu_count
	var prev_hz = Global.FREQ_MIN
	var colors = [Color.WHITE, ]
	for i in range(1, Global.vu_count + 1):
		var hz = (i * (Global.FREQ_MAX + Global.FREQ_MIN) / Global.vu_count) + \
				Global.FREQ_MIN
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((Global.MIN_DB + linear_to_db(magnitude)) / Global.MIN_DB, 0, 1)
		var height = energy * Global.HEIGHT
		draw_rect(Rect2(w * i + 100, Global.HEIGHT - height, w, height), Global.STREAM_COLORS[3])
		prev_hz = hz
