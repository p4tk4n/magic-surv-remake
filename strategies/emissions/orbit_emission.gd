class_name OrbitEmission
extends EmissionStrategy

func emit(controller: SpellController) -> void:
	controller.clear_projectiles()
	var count: int = controller.current_stats.count
	for i in count:
		var proj := controller.spawn_projectile()
		proj.orbit_angle_offset = (TAU / count) * i

func on_removed(controller: SpellController) -> void:
	controller.clear_projectiles()
