class_name ScreenEdgeWaveEmission
extends EmissionStrategy

@export var spacing: float = 128
@export var angle_degrees: float = 45.0  # 0 = straight down, 45 = top-left to bottom-right

func emit(controller: SpellController) -> void:
	var rect := controller.get_camera_world_rect()
	var count: int = controller.current_stats.count
	var margin := 200.0  # bigger margin helps since diagonal travel covers more screen

	var travel_dir := Vector2.DOWN.rotated(deg_to_rad(angle_degrees))
	var spread_dir := travel_dir.rotated(PI / 2.0)  # perpendicular to travel = the "line" the waves are spaced along

	var center := controller.player.global_position
	var spawn_center := center - travel_dir * (rect.size.length() * 0.5 + margin)

	var start_offset := -(float(count - 1) * spacing) * 0.5

	for i in count:
		var proj := controller.spawn_projectile()
		var offset := start_offset + i * spacing
		var random_offset_y = randi_range(-15,15)
		var random_offset_x = randi_range(-20,20)
		
		proj.global_position = (spawn_center + Vector2(random_offset_x,random_offset_y)) + spread_dir * offset
		proj.direction = travel_dir
