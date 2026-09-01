class_name NearestEnemyEmission
extends EmissionStrategy

@export var stagger_delay: float = 0.05

func emit(controller: SpellController) -> void:
	for i in controller.current_stats.count:
		var target := controller.get_nearest_enemy()
		if not target:
			return
		var proj := controller.spawn_projectile()
		proj.direction = (target.global_position - proj.global_position).normalized()

		if i < controller.current_stats.count - 1:
			await controller.get_tree().create_timer(stagger_delay).timeout
