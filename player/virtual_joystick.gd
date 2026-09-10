extends VirtualJoystick

func _ready() -> void:
	joystick_size = global.joystick_scales[global.current_joystick_size]
	tip_size = global.joystick_scales[global.current_joystick_size] * 0.5
