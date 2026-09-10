extends Control

@onready var joystick_size_label: Label = $Settings/JoystickSizeLabel
@onready var joystick_size_button: Button = $Settings/JoystickSizeButton

enum joystick_sizes{
	SMALL, MEDIUM, LARGE
}

func _ready() -> void:
	joystick_size_button.text = str(joystick_sizes.find_key(global.current_joystick_size))

func _on_joystick_size_button_pressed() -> void:
	if global.current_joystick_size < 2:
		global.current_joystick_size += 1
	else:
		global.current_joystick_size = 0
	joystick_size_button.text = str(joystick_sizes.find_key(global.current_joystick_size))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(global.scenes["main_menu"])

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(global.scenes["main_menu"])
