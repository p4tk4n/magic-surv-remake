class_name SpreadNearestEnemyEmission
extends EmissionStrategy

@export var stagger_delay: float = 0.05
@export var spread_angle: float = 50.0

func emit(controller: SpellController) -> void:
	for i in controller.current_stats.count:
		var target := controller.get_nearest_enemy()
		if not target:
			return
		
		var proj := controller.spawn_projectile()
		var random_offset = randf_range(-spread_angle, spread_angle)
		var direction = target.global_position - proj.global_position
		var angle = direction.angle() + deg_to_rad(random_offset)
		proj.direction = Vector2(cos(angle), sin(angle)).normalized()
		proj.rotation = angle
		if i < controller.current_stats.count - 1:
			await controller.get_tree().create_timer(stagger_delay).timeout
