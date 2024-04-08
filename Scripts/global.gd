extends Node

const PROGRAM_SONGS = [
	"Anyone",
	"Circle the Drain",
	"Dharma",
	"Hangman",
	"Like a Shadow",
	"Mt Eden",
	"Plastic Heart",
]

const DISPLAY_MODES = [
	"Individual",
	"Layered",
]

const CAMERA_MODES = [
	"Free",
	"Orthographic",
	"Animated",
]

const STEMS = [
	"Bass",
	"Drums",
	"Other",
	"Piano",
	"Vocal",
]

const BUS_NAMES = [
	&"Bass Bus",
	&"Drum Bus",
	&"Other Bus",
	&"Piano Bus",
	&"Vocal Bus",
]

# 0 = Bins, 1 = Scale, 2 = Bin Width, 3 = Freq Min, 4 = Freq Max,
#	5 = Min DB, 6 = Separation
enum UISLIDERS {
	BINS = 0,
	SCALE = 1,
	BIN_WIDTH = 2,
	FREQ_MIN = 3,
	FREQ_MAX = 4,
	MIN_DB = 5,
	SEPARATION = 6,
}

func get_program_song_path(song: String, stem=null) -> String:
	return ("res://Audio Samples/" + song + "/" + song + 
		((" - " + stem) if stem else "") + ".mp3")

func get_all_program_song_paths(song: String) -> Array:
	var paths = []
	# paths.append(get_program_song_path(song))
	for stem in STEMS:
		paths.append(get_program_song_path(song, stem))
	return paths


# ToDo delete old constants






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
