extends Panel

signal stem_update(new_val, stem_ID)
signal stem_checkbox_update(toggled_on, stem_ID)

@export var stem_ID = -1
@export var title = "Slider Name"
@export var val_step : float = 1
@export var init_value : float = 0
@export var max_value : float = 100
@export var min_value : float = 0

@onready var _is_dragging = false

@onready var num_label = get_node("VBoxContainer/Bottom/NumberLabel")
@onready var label_title = get_node("VBoxContainer/Top/Title")
@onready var slider = get_node("VBoxContainer/Bottom/HSlider")
@onready var checkbox = get_node("VBoxContainer/Top/CheckBox")

func _ready():
	label_title.text = title
	slider.max_value = max_value
	slider.min_value = min_value
	slider.step = val_step
	slider.value = init_value

func _on_check_box_toggled(toggled_on):
	slider.editable = toggled_on
	
	if toggled_on:
		slider.modulate = Color.WHITE
		num_label.modulate = Color.WHITE
		#label_title.modulate = Color.WHITE
		#num_label.modulate = Color.WHITE
	else:
		slider.modulate = Color.BLACK
		num_label.modulate = Color.BLACK
		#label_title.modulate = Color.BLACK
		#num_label.modulate = Color.BLACK
		
	emit_signal("stem_checkbox_update", toggled_on, stem_ID)


func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		num_label.text = str(slider.value)
		emit_signal("stem_update", slider.value, stem_ID)
	_is_dragging = false


func _on_h_slider_drag_started():
	_is_dragging = true


# Whenever the slider moves, this fires
# Sets the text, and signals the new value with who 
# 	it came from
# If this signal triggers an expensive process, then 
# 	a "debouncing Timer" is recomended to call the 
# 	function less often, to save on resources
func _on_h_slider_value_changed(value):
	num_label.text = str(value)
	if _is_dragging == false:
		emit_signal("stem_update", value, stem_ID)
