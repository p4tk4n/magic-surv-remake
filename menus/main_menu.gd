extends Control

@onready var start_button: JuicyButton = $StartButton
@onready var settings_button: JuicyButton = $SettingsButton
@onready var quit_button: JuicyButton = $QuitButton

var map_scene: PackedScene = global.scenes["map"]
var settings_scene: PackedScene = global.scenes["settings"]

func _ready() -> void:
	global.current_scene = global.scenes["main_menu"]

func _on_start_button_pressed() -> void:
	global.switch_scene(map_scene)
	
func _on_settings_button_pressed() -> void:
	global.switch_scene(settings_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

	
