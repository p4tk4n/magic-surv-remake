class_name SingleHitOnHit
extends OnHitStrategy

@export var despawn_delay: float = 0.0

func resolve(projectile: Projectile, enemy: Node2D) -> void:
	if enemy.has_method("take_damage"):
		enemy.take_damage(projectile.damage)
	
	if despawn_delay:
		await projectile.get_tree().create_timer(despawn_delay).timeout
	projectile.queue_free()
	
