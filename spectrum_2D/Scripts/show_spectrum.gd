extends Node2D

#var vocal_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Vocal.mp3")
#var drum_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Drum.mp3")
#var other_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Other.mp3")
#var piano_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Piano.mp3")
#var bass_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Bass.mp3")

var bassIndex
var drumIndex
var otherIndex
var pianoIndex
var vocalIndex

func _ready():
	bassIndex = AudioServer.get_bus_index("Bass Bus")
	drumIndex = AudioServer.get_bus_index("Drum Bus")
	otherIndex = AudioServer.get_bus_index("Other Bus")
	pianoIndex = AudioServer.get_bus_index("Piano Bus")
	vocalIndex = AudioServer.get_bus_index("Vocal Bus")

# Volumes should be in the following order:
# Bass, Drum, Other, Piano, Vocal
# i.e., alphabetical
func change_amps(new_volumes):
	AudioServer.set_bus_volume_db(bassIndex, linear_to_db(new_volumes[0]))
	AudioServer.set_bus_volume_db(drumIndex, linear_to_db(new_volumes[1]))
	AudioServer.set_bus_volume_db(otherIndex, linear_to_db(new_volumes[2]))
	AudioServer.set_bus_volume_db(pianoIndex, linear_to_db(new_volumes[3]))
	AudioServer.set_bus_volume_db(vocalIndex, linear_to_db(new_volumes[4]))
