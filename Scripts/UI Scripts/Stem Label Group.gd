extends Node3D

@onready var v_label = get_node("Vocal")
@onready var p_label = get_node("Piano")
@onready var o_label = get_node("Other")
@onready var d_label = get_node("Drum")
@onready var b_label = get_node("Base")

@onready var labels = [v_label, p_label, o_label, d_label, b_label]
#@onready var labels_visible = true

@export var max_seperation : float = 5.0

func check_visibility(new_sep):
	if new_sep < 0.25 and visible == true:
		visible = false
		
		#for label in labels:
			#label.set_visibility(visible)
	elif new_sep > 0.25 and visible == false:
		visible = true
		
		#for label in labels:
			#label.set_visibility(visible)
		

# New value ranges from 0 to 10
# Initial seperation is 2.5m with a value of 5/10
func _on_ui_canvas_update_spectrogram(new_val, slider_ID):
	
	# Make sure the other sliders don't mess with us
	if (slider_ID != 6):
		return
	
	var new_seperation = max_seperation * (new_val / 10)
	
	for label_index in labels.size():
		#print("New sep: ", new_seperation * label_index)
		labels[label_index].transform.origin.y = new_seperation * label_index
	
	check_visibility(new_seperation)
