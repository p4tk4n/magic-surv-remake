# res://spells/strategies/on_hits/split_on_hit.gd
class_name SplitOnHit
extends OnHitStrategy

@export var split_count: int = 6
@export var split_damage_ratio: float = 0.5
@export var fragment_speed_multiplier: float = 1.2
@export var fragment_on_hit: OnHitStrategy  # what fragments do when THEY hit something

func resolve(projectile: Projectile, enemy: Node2D) -> void:
	if enemy.has_method("take_damage"):
		enemy.take_damage(projectile.damage)
	print("fragged")
	var controller := projectile.controller
	var hit_pos := projectile.global_position

	for i in split_count:
		var angle := (TAU / split_count) * i
		var angle_offset := deg_to_rad(randi_range(-10, 10))
		var frag := controller.spawn_projectile(hit_pos, fragment_on_hit)
		frag.spawn_grace_period = 0.05
		frag.direction = Vector2.RIGHT.rotated(angle + angle_offset)
		frag.damage = projectile.damage * split_damage_ratio
		frag.speed = projectile.speed * fragment_speed_multiplier
		frag.lifetime = 0.8
	projectile.queue_free()
