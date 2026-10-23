class_name ProjectileTrail
extends Line2D

var _data: TrailData
var _target: Node2D

func setup(data: TrailData, target: Node2D, alt_color = 0) -> void:
	_data = data
	_target = target
	top_level = true
	global_position = Vector2.ZERO
	default_color = data.gradient.get_color(1.0)
	width = data.width
	width_curve = data.width_curve
	gradient = data.gradient
	texture = data.texture
	texture_mode = data.texture_mode
	if data.additional:
		var mat := CanvasItemMaterial.new()
		mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		material = mat
	clear_points()
	add_point(target.global_position)
	
func _process(delta: float) -> void:
	if not is_instance_valid(_target):
		return
	var pos := _target.global_position
	var count := get_point_count()
	if count < 2 or get_point_position(count - 2).distance_to(pos) >= _data.point_spacing:
		add_point(pos)
		if get_point_count() > _data.max_points:
			remove_point(0)
	else:
		set_point_position(count - 1, pos)
