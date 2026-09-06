class_name UniqueTargetEmission
extends EmissionStrategy

func emit(controller: SpellController) -> void:
	var already_targeted: Array[Node2D] = []
	var count: int = controller.current_stats.count

	for i in count:
		var target := _get_nearest_unhit_enemy(controller, already_targeted)
		if not target:
			break

		already_targeted.append(target)

		var proj := controller.spawn_projectile()
		proj.direction = (target.global_position - proj.global_position).normalized()

func _get_nearest_unhit_enemy(controller: SpellController, exclude: Array[Node2D]) -> Node2D:
	var enemies := controller.get_tree().get_nodes_in_group("enemy")
	var nearest: Node2D = null
	var best_dist := INF

	for e in enemies:
		if e in exclude:
			continue
		var d := controller.player.global_position.distance_squared_to(e.global_position)
		if d < best_dist:
			best_dist = d
			nearest = e

	return nearest
