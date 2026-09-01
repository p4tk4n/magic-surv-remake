class_name LinearMovement
extends MovementStrategy

func move(projectile: Projectile, delta: float) -> void:
	projectile.position += projectile.direction * projectile.speed * delta
