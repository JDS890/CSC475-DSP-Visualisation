extends Node3D


# @export var bus_names: Array = ["Original Bus", "Bass Bus", "Drum Bus", "Fusion Bus", "Piano Bus"]
@export var bus_names: Array = ["Original Bus"]

const MAX_SPECTROGRAMS: int = 5
const MAX_VU_COUNT: int = 256

var ae_instances: Array = []
var spectrums: Array = []

# Note to self: vu_count is the number of vertical bars in the spectrogram

func _ready():

	# var node: MeshInstance3D = get_node("S1").get_child(0)
	# get material
	# print(node)
	# print(node.position)
	# print(node.get_surface_override_material(0)) 
	 # var a = node.



	# print(node.get_surface_material(0))
	
		# print children
	# for child in node.get_children():
	#     print(child)
	
	# get child named "Cube"


	for i in range(min(bus_names.size(), MAX_SPECTROGRAMS)):
		ae_instances.append(AudioServer.get_bus_effect_instance( AudioServer.get_bus_index(bus_names[i]), 0 ))
		spectrums.append(PackedFloat32Array())
		spectrums[i].resize(MAX_VU_COUNT)
		spectrums[i].fill(1.0)


func _process(delta):

	for j in range(ae_instances.size()):

		var prev_hz = Global.FREQ_MIN
		var spectrum = ae_instances[j]

		for i in range(Global.vu_count):
			var hz = ((i + 1) * (Global.FREQ_MIN + Global.FREQ_MAX) / Global.vu_count) + Global.FREQ_MIN
			var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
			var energy = clamp((Global.MIN_DB + linear_to_db(magnitude)) / Global.MIN_DB, 0, 1)
			spectrums[j][i] = energy * Global.HEIGHT
			prev_hz = hz
	
		# Send the spectrum to the shader
		get_node("S1").get_child(0).get_surface_override_material(0).set_shader_parameter("heights", spectrums[j])
		print(delta)

		#  get_node("S1").set("spectrum" + str(j), spectrums[j])

