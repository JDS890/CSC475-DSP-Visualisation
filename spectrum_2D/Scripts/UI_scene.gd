extends Control


@onready var p_spec = $"HBoxContainer/PanelContainer/BaseSpectro/PianoSpectro"
@onready var d_spec = $"HBoxContainer/PanelContainer/BaseSpectro/DrumSpectro"
@onready var o_spec = $"HBoxContainer/PanelContainer/BaseSpectro/OtherSpectro"
@onready var v_spec = $"HBoxContainer/PanelContainer/BaseSpectro/VoiceSpectro"

# p_spec.visible = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# boice
func _on_check_box_toggled_1(toggled_on):
	v_spec.visible = toggled_on
