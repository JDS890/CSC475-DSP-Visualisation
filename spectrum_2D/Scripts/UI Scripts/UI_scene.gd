extends Control

var _hidden_UI = false

# todo: keypress to hide all UI (hit H button)
# play and stop button
# seek to different time


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):	
	# Receives key input
	if event is InputEventKey:
		match event.keycode:
			KEY_H:
				_hidden_UI = !_hidden_UI
				self.visible = _hidden_UI

# boice
func _on_check_box_toggled_1(toggled_on):
	pass
