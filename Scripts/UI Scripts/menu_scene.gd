extends Control

@onready var stem_group = get_node("StemLabelGroup")
@onready var bass_label = get_node("StemLabelGroup/BassLabel")
@onready var drum_label = get_node("StemLabelGroup/DrumLabel")
@onready var other_label = get_node("StemLabelGroup/OtherLabel")
@onready var piano_label = get_node("StemLabelGroup/PianoLabel")
@onready var vocal_label = get_node("StemLabelGroup/VocalLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$FileDialog.popup()


func _on_file_dialog_dir_selected(dir):
	print("YES!", dir)
	var globals_to_add = parse_dir(dir)
	# todo: add to global list of songs

func parse_dir(dir_path):
	var dir = DirAccess.open(dir_path)
	var global_add = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_file():
				if string_matcher(file_name):
					global_add.append(file_name)
			file_name = dir.get_next()
	else:
		print("Something's gone wrong with the dir!")
		

	# var stroing = Global.res_path + "/" + Global.songname + "/" + Global.songname + " - Bass.mp3"
	var stroing = Global.res_path + "/" + Global.songname + "/" + Global.songname + " - Bass.mp3"

func string_matcher(str):
	var regexer = RegEx.new()
	regexer.compile("")
	
	if true:
		return true
	else:
		return false
