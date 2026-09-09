extends Control

@onready var start_button: JuicyButton = $StartButton
@onready var settings_button: JuicyButton = $SettingsButton
@onready var quit_button: JuicyButton = $QuitButton

var map_scene: PackedScene = global.scenes["map"]
var settings_scene: PackedScene = global.scenes["settings"]

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(map_scene)

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(settings_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
		
	
