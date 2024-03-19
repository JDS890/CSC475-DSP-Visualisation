extends Node2D

#var vocal_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Vocal.mp3")
#var drum_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Drum.mp3")
#var other_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Other.mp3")
#var piano_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Piano.mp3")
#var bass_sound = load("res://Audio Samples/Like a Shadow/Like a Shadow - Bass.mp3")

var bassPlayer
var drumPlayer
var otherPlayer
var pianoPlayer
var vocalPlayer

func _ready():
	bassPlayer = get_node("BassStream/BassStream")
	drumPlayer = get_node("DrumStream/DrumStream")
	otherPlayer = get_node("OtherStream/OtherStream")
	pianoPlayer = get_node("PianoStream/PianoStream")
	vocalPlayer = get_node("VocalStream/VocalStream")

# Volumes should be in the following order:
# Bass, Drum, Other, Piano, Vocal
# i.e., alphabetical
func change_amps(new_volumes):
	bassPlayer.set_volume_db(new_volumes[0])
	drumPlayer.set_volume_db(new_volumes[1])
	otherPlayer.set_volume_db(new_volumes[2])
	pianoPlayer.set_volume_db(new_volumes[3])
	vocalPlayer.set_volume_db(new_volumes[4])
