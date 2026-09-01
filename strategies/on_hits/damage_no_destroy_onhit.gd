class_name DamageNoDestroyOnHit
extends OnHitStrategy

func resolve(projectile: Projectile, enemy: Node2D) -> void:
	if enemy.has_method("take_damage"):
		enemy.take_damage(projectile.damage)
