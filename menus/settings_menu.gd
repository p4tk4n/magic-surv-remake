extends Control

@onready var joystick_size_label: Label = $Settings/JoystickSizeLabel
@onready var joystick_size_button: TextureButton = $Settings/JoystickSizeButton
@onready var size_label: Label = $Settings/JoystickSizeButton/SizeLabel

enum joystick_sizes{
	SMALL, MEDIUM, LARGE
}

func _ready() -> void:
	size_label.text = str(joystick_sizes.find_key(global.current_joystick_size))

func _on_joystick_size_button_pressed() -> void:
	if global.current_joystick_size < 2:
		global.current_joystick_size += 1
	else:
		global.current_joystick_size = 0
	size_label.text = str(joystick_sizes.find_key(global.current_joystick_size))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		global.switch_scene(global.scenes["main_menu"])

func _on_texture_button_pressed() -> void:
	global.switch_scene(global.previous_scene)
	
