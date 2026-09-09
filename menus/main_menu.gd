extends Control

@onready var start_button: JuicyButton = $StartButton
@onready var settings_button: JuicyButton = $SettingsButton
@onready var quit_button: JuicyButton = $QuitButton

var map_scene: PackedScene = load("res://map/map.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(map_scene)

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
		
	
