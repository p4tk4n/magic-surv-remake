class_name NearestEnemyEmission
extends EmissionStrategy

func emit(controller: SpellController) -> void:
	var target := controller.get_nearest_enemy()
	if not target:
		return
	for i in controller.current_stats.count:
		var proj := controller.spawn_projectile()
		proj.direction = (target.global_position - proj.global_position).normalized()
