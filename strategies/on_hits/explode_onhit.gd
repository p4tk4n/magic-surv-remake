class_name ExplodeOnHit
extends OnHitStrategy

@export var explosion_radius: float = 100.0
@export var explosion_damage_ratio: float = 1.0   # % of the projectile's own damage dealt to splash targets
@export var hits_original_target_directly: bool = true  # if true, primary target takes full damage, others take splash

@export var explosion_effect_scene: PackedScene = preload("res://spells/effects/explosion_effect.tscn")
@export var explosion_frames: SpriteFrames
@export var explosion_scale: float = 1.0
@export var sprite_size: float = 64.0

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
	if not explosion_frames: return
	
	var effect := explosion_effect_scene.instantiate() as ExplosionEffect
	effect.sprite_frames = explosion_frames
	effect.global_position = pos
	effect.scale = Vector2.ONE * (explosion_radius / sprite_size) #sprite size
	controller.get_tree().current_scene.add_child.call_deferred(effect)
	
