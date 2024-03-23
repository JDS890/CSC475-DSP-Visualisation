extends Node3D

# # @export var bus_names: Array = ["Original Bus", "Bass Bus", "Drum Bus", "Fusion Bus", "Piano Bus"]
# @export var bus_names: Array = ["Original Bus"]

# const MAX_SPECTROGRAMS: int = 5
# const MAX_VU_COUNT: int = 256

# var ae_instances: Array = []
# var spectrums: Array = []

# # Note to self: vu_count is the number of vertical bars in the spectrogram

# func _ready():
# 	for i in range(min(bus_names.size(), MAX_SPECTROGRAMS)):
# 		ae_instances.append(AudioServer.get_bus_effect_instance( AudioServer.get_bus_index(bus_names[i]), 0 ))
# 		spectrums.append(PackedFloat32Array())
# 		spectrums[i].resize(MAX_VU_COUNT)
# 		spectrums[i].fill(1.0)


# func _process(_delta):
# 	var w = Global.WIDTH / Global.vu_count
# 	var prev_hz = Global.FREQ_MIN

# 	# I'm fairly sure i should be zero-indexed here
# 	for i in range(1, Global.vu_count + 1):
# 		var hz = (i * (Global.FREQ_MAX + Global.FREQ_MIN) / Global.vu_count) + Global.FREQ_MIN
# 		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
# 		var energy = clamp((Global.MIN_DB + linear_to_db(magnitude)) / Global.MIN_DB, 0, 1)
# 		var height = energy * Global.HEIGHT
# 		draw_rect(Rect2(w * i + 450, Global.HEIGHT - height + 150, w, height), Global.STREAM_COLORS[3])
# 		prev_hz = hz

