class_name OrbitMovement
extends MovementStrategy

@export var radius: float = 60.0
@export var angular_speed: float = 2.0

func move(projectile: Projectile, delta: float) -> void:
	projectile.orbit_angle_offset += angular_speed * delta
	var pivot := projectile.controller.player.global_position
	projectile.global_position = pivot + Vector2.RIGHT.rotated(projectile.orbit_angle_offset) * radius
