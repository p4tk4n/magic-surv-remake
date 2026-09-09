class_name DamageNoDestroyOnHit
extends OnHitStrategy

@export var tick_interval: float = 0.2

func resolve(projectile: Projectile, enemy: Node2D) -> void:
	if enemy.has_method("take_damage"):
		enemy.take_damage(projectile.damage)
