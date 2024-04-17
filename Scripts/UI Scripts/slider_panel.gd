extends Panel

signal slider_update(new_val, slider_ID)

@export var slider_ID = -1
@export var title = "Slider Name"
@export var val_step : float = 1
@export var init_value : float = 0
@export var max_value : float = 100
@export var min_value : float = 0

@onready var _is_dragging = false

@onready var num_label = get_node("VBoxContainer/Control/NumberLabel")
@onready var label_title = get_node("VBoxContainer/Title")
@onready var slider = get_node("VBoxContainer/Control/HSlider")

func _ready():
	label_title.text = title
	slider.max_value = max_value
	slider.min_value = min_value
	slider.step = val_step
	slider.value = init_value

# Whenever the slider moves, this fires
# Sets the text, and signals the new value with who 
# 	it came from
# If this signal triggers an expensive process, then 
# 	a "debouncing Timer" is recomended to call the 
# 	function less often, to save on resources
# I've changed this now to only respond to the scroll wheel,
#	since relying solely on drag_ended cuts out the wheel
func _on_h_slider_value_changed(value):
	num_label.text = str(value)
	#if _is_dragging == false:
	emit_signal("slider_update", value, slider_ID)


func _on_h_slider_drag_started():
	_is_dragging = true


func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		num_label.text = str(slider.value)
		emit_signal("slider_update", slider.value, slider_ID)
	_is_dragging = false
	
