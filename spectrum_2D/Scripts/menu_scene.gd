extends Control

# @onready var 

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
	parse_dir(dir)

func parse_dir(dir_path):
	var dir = DirAccess.open(dir_path)
	if dir_path:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("Something's gone wrong with the dir!")
		
	# var stroing = Global.res_path + "/" + Global.songname + "/" + Global.songname + " - Bass.mp3"
