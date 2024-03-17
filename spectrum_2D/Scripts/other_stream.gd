extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0 * 10

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

#var OtherStream
#var other
var spectrum

func _ready():
	#OtherStream = get_node("OtherStream")
	#other = OtherStream.stream()
	#other = AudioServer.get_bus_effect_instance(2,0)
	#var effect = AudioEffectSpectrumAnalyzer.new()
	#AudioServer.add_bus_effect(0, effect)
	#
	#var analyzer_instance = AudioEffectSpectrumAnalyzer.new()
	#analyzer_instance.set_effect(effect)
#
	#other.add_effect_instance(analyzer_instance)
	spectrum = AudioServer.get_bus_effect_instance(4,0)

func _process(_delta):
	queue_redraw()

func _draw():
	#warning-ignore:integer_division
	var w = WIDTH / VU_COUNT
	var prev_hz = 0
	var colors = [Color.RED, ]
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height + 450, w, height), Color.RED)
		prev_hz = hz
