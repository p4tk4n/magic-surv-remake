extends Node

func _ready() -> void:
	if OS.has_feature("mobile"):
		DisplayServer.window_set_size(global.window_size_mobile)
		#DisplayServer.window_set_position(_get_centered_pos(global.window_size_mobile))

func _get_centered_pos(size: Vector2i) -> Vector2i:
	var screen_size = DisplayServer.screen_get_size()
	return (screen_size - size) * .5
