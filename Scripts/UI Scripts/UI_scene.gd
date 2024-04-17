extends Control

var _hidden_UI = false
signal update_stem(new_val, stem_ID)
signal toggle_stem(toggled_on, stem_ID, stem_val)
signal update_spectrogram(new_val, slider_ID)
signal toggle_playstop(toggled_on)
signal track_seek(track_poz)

@onready var stem_signal_bus = get_node("HBoxContainer/LeftBar")
@onready var spectro_signal_bus = get_node("HBoxContainer/RightBar")
@onready var song_label = get_node("HBoxContainer/Middle Spacer/SongLabel")
@onready var track_bar = get_node("HBoxContainer/Middle Spacer/TrackSlider")

# Called when the node enters the scene tree for the first time.
# Loops through the slider prefab children and listens to their signals.
func _ready():
	var stem_controls = stem_signal_bus.get_children()
	for controller in stem_controls:
		if controller.name == "PlayStopContainer":
			pass
		else:
			print(controller)
			controller.stem_update.connect(stem_control_response)
			controller.stem_checkbox_update.connect(stem_check_response)
		
	var spectro_controls = spectro_signal_bus.get_children()
	for controller in spectro_controls:
		controller.slider_update.connect(spectro_control_response)

# Logic for hiding the UI on button press
func _input(_event):
	if Input.is_action_just_pressed("hide_UI"):
		_hidden_UI = !_hidden_UI
		self.visible = _hidden_UI

# These IDs are associated with each slider in the order they
# 	they appear in the UI.
# Basically, 0 = Base, 1 = Drum, 2 = Other, 3 = Piano, 
#	and 4 = Vocal
func stem_control_response(new_val, stem_ID):
	#print("New val: ", new_val, " stem ID: ", stem_ID)
	emit_signal("update_stem", new_val, stem_ID)
	
# Basically, 0 = Base, 1 = Drum, 2 = Other, 3 = Piano, 
#	and 4 = Vocal
func stem_check_response(toggled_on, stem_ID, stem_val):
	#print("Toggle: ", toggled_on, " stem ID: ", stem_ID)
	print(stem_val)
	emit_signal("toggle_stem", toggled_on, stem_ID, stem_val)

# 0 = Bins, 1 = Scale, 2 = Bin Width, 3 = Freq Min, 4 = Freq Max,
#	5 = Min DB, 6 = Seperation
func spectro_control_response(new_val, slider_ID):
	#print("New val: ", new_val, " slider ID: ", slider_ID)
	emit_signal("update_spectrogram", new_val, slider_ID)

# Specifically the music play / pause button
func _on_check_box_toggled(toggled_on:bool):
	emit_signal("toggle_playstop", toggled_on)

# Emits a value from 0 to 100
func _on_track_slider_drag_ended(value_changed):
	if value_changed:
		emit_signal("track_seek", track_bar.value)
