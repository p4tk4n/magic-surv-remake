class_name AtEnemyEmission
extends EmissionStrategy

@export var stagger_delay: float = 0.01
@export var proj_offset: Vector2 = Vector2(0,0)

func emit(controller: SpellController) -> void:
	var shot_enemies = []
	for i in controller.current_stats.count:
		var target := controller.get_nearest_enemy(shot_enemies)
		if not target:
			return
		shot_enemies.append(target)
		var proj := controller.spawn_projectile()
		proj.global_position = target.global_position + proj_offset
		proj.direction = Vector2(0,0)
		
		if i < controller.current_stats.count - 1:
			await controller.get_tree().create_timer(stagger_delay).timeout
