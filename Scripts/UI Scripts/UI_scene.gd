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
@onready var camera_label = get_node("HBoxContainer/Middle Spacer/CameraLabel")
@onready var display_mode_label = get_node("HBoxContainer/Middle Spacer/DisplayModeLabel")
@onready var track_bar = get_node("HBoxContainer/Middle Spacer/TrackSlider")
@onready var track_bar_held : bool = false

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

	song_label.text = Global.PROGRAM_SONGS[4]
	camera_label.text = Global.CAMERA_MODES[Global.current_camera_mode]
	display_mode_label.text = Global.DISPLAY_MODES[Global.current_display_mode]

# Logic for hiding the UI on button press
func _input(_event):
	if Input.is_action_just_pressed("hide_UI"):
		_hidden_UI = !_hidden_UI
		self.visible = _hidden_UI
	elif Input.is_action_just_pressed("change_song"):
		track_bar.value = 0
		await get_tree().create_timer(0.05).timeout
		#print("Changed song to name", Global.songname)
		song_label.text = Global.songname
	elif Input.is_action_just_pressed("change_mode"):
		await get_tree().create_timer(0.05).timeout
		display_mode_label.text = Global.DISPLAY_MODES[Global.current_display_mode]
	elif Input.is_action_just_pressed("change_camera"):
		await get_tree().create_timer(0.05).timeout
		camera_label.text = Global.CAMERA_MODES[Global.current_camera_mode]

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
	track_bar_held = false
	if value_changed:
		emit_signal("track_seek", track_bar.value)

# This was Josh's solution to click seeking rather than drag seeking
# This signal is sent also when the value is changed by CODE!
# So I added a lock to avoid the code updates from making things janky
func _on_track_slider_value_changed(value:float):
	if track_bar_held == true:
		emit_signal("track_seek", track_bar.value)

# This one listens to the Spectrograms parent node!
# It gets info on current progress to update the var
func _on_spectrograms_update_track_progress(curr_progress):
	# Don't want to compete against the user
	if track_bar_held == false:
		track_bar.value = curr_progress

# Basically locks the _process update signalling from Spectrogram.gd
func _on_track_slider_drag_started():
	track_bar_held = true
