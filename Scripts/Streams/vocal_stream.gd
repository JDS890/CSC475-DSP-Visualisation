extends Node2D

var audiostream
var spectrum

func _ready():
	#audiostream = get_node("VocalStream")
	$VocalStream.stream = load(Global.res_path + "/" +
							  Global.songname + "/" +
							  Global.songname + " - Vocal.mp3")
	$VocalStream.play()

	spectrum = AudioServer.get_bus_effect_instance(
		AudioServer.get_bus_index("Vocal Bus"),
		0
	)

func _process(_delta):
	queue_redraw()

func _draw():
	#warning-ignore:integer_division
	var w = Global.WIDTH / Global.vu_count
	var prev_hz = Global.FREQ_MIN
	for i in range(1, Global.vu_count + 1):
		var hz = (i * (Global.FREQ_MAX + Global.FREQ_MIN) / Global.vu_count) + \
				Global.FREQ_MIN
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((Global.MIN_DB + linear_to_db(magnitude)) / Global.MIN_DB, 0, 1)
		var height = energy * Global.HEIGHT
		draw_rect(Rect2(w * i, Global.HEIGHT - height + 150, w, height), Global.STREAM_COLORS[4])
		prev_hz = hz
