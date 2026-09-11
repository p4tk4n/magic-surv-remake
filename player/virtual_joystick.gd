extends VirtualJoystick

func _ready() -> void:
	if not OS.has_feature("mobile"): visible = false
	joystick_size = global.joystick_scales[global.current_joystick_size]
	tip_size = global.joystick_scales[global.current_joystick_size] * 0.5
