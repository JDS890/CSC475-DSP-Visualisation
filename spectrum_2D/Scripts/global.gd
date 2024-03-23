extends Node

# Stream constants
var vu_count = 256
const FREQ_MIN = 100
const FREQ_MAX = 15000.0
const WIDTH = 400
const HEIGHT = 100
const MIN_DB = 60

# Music
const songs = ["Circle the Drain", "Hangman", "Like a Shadow",
				"Dharma", "Plastic Heart", "Mt Eden", "Anyone"]
const songname = songs[0]
const res_path = "res://Audio Samples/"

# Probably not needed, but here just in case
# Colours should be in the following order:
# Bass, Drum, Other, Piano, Vocal
# i.e., alphabetical
const STREAM_COLORS = [Color.WHITE, Color.BLUE, Color.PURPLE, Color.GREEN, Color.RED]
