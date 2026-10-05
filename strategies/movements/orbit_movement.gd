class_name OrbitMovement
extends MovementStrategy

@export var radius: float = 60.0
@export var base_angular_speed: float = 2.0

var speed: float

func move(projectile: Projectile, delta: float) -> void:
	if not is_instance_valid(projectile.controller):
		projectile.queue_free()
		return
	speed = base_angular_speed
	if projectile.controller.current_stats.extra.has("angular_speed"):
		speed = projectile.controller.current_stats.extra.get("angular_speed")
	
	projectile.orbit_angle_offset += speed * delta
	var pivot := projectile.controller.player.global_position
	projectile.global_position = pivot + Vector2.RIGHT.rotated(projectile.orbit_angle_offset) * radius
