class_name ExplodeOnHit
extends OnHitStrategy

@export var explosion_radius: float = 100.0
@export var explosion_damage_ratio: float = 1.0   # % of the projectile's own damage dealt to splash targets
@export var hits_original_target_directly: bool = true  # if true, primary target takes full damage, others take splash

func resolve(projectile: Projectile, enemy: Node2D) -> void:
	var controller := projectile.controller
	var center := projectile.global_position

	if hits_original_target_directly and enemy.has_method("take_damage"):
		enemy.take_damage(projectile.damage)

	var splash_damage := projectile.damage * explosion_damage_ratio

	for other in controller.get_tree().get_nodes_in_group("enemy"):
		if other == enemy and hits_original_target_directly:
			continue  # already hit directly above, don't double-dip
		if not other.has_method("take_damage"):
			continue
		var dist := center.distance_to(other.global_position)
		if dist <= explosion_radius:
			other.take_damage(splash_damage)

	_spawn_explosion_visual(controller, center)
	projectile._despawn()

func _spawn_explosion_visual(controller: SpellController, pos: Vector2) -> void:
	pass  # optional — fill in once logic is confirmed working
