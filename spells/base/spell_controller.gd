class_name SpellController
extends Node

signal mutated(mutation_data: MutationData)

var data: SpellData
var level: int = 1
var current_stats: SpellLevelData
var player: Node2D
var timer: Timer
var is_mutated: bool = false

var active_projectile_scene: PackedScene
var active_emission: EmissionStrategy
var active_movement: MovementStrategy
var active_on_hit: OnHitStrategy

var _live_projectiles: Array[Projectile] = []

func setup(spell_data: SpellData, p: Node2D) -> void:
	data = spell_data
	player = p
	current_stats = data.levels[0]
	active_projectile_scene = data.projectile_scene
	active_emission = data.emission_strategy
	active_movement = data.movement_strategy
	active_on_hit = data.on_hit_strategy
	print(active_on_hit)
	
	if not data.is_persistent:
		timer = Timer.new()
		timer.wait_time = data.cooldown * (1.0 - current_stats.cooldown_reduction)
		timer.timeout.connect(func(): active_emission.emit(self))
		add_child(timer)
		timer.start()
	else:
		active_emission.emit(self)
	
	print("player ref: ", player)
	
func level_up() -> void:
	if is_mutated:
		return
	
	level += 1	
	
	if level > data.levels.size() and data.mutation:
		_apply_mutation(data.mutation)
		global.unavailable_spells.append(data.spell_name)
		return

	if level <= data.levels.size():
		current_stats = data.levels[level - 1]
		active_emission.emit(self)

func _apply_mutation(mutation: MutationData) -> void:
	active_emission.on_removed(self)

	if mutation.projectile_scene:
		active_projectile_scene = mutation.projectile_scene
	if mutation.emission_strategy:
		active_emission = mutation.emission_strategy
	if mutation.movement_strategy:
		active_movement = mutation.movement_strategy
	if mutation.on_hit_strategy:
		active_on_hit = mutation.on_hit_strategy
		print("active_on_hit set to: ", active_on_hit, " (", active_on_hit.get_script(), ")")
	else:
		print("mutation.on_hit_strategy was NULL, active_on_hit unchanged: ", active_on_hit)
	if mutation.cooldown > 0:
		timer.wait_time = mutation.cooldown

	current_stats = mutation.mutated_stats
	is_mutated = true
	mutated.emit(mutation)
	active_emission.emit(self)

# spell_controller.gd
func spawn_projectile(spawn_pos: Vector2 = Vector2.INF, override_on_hit: OnHitStrategy = null) -> Projectile:
	var proj := active_projectile_scene.instantiate() as Projectile
	proj.controller = self
	proj.movement = active_movement
	proj.on_hit = override_on_hit if override_on_hit else active_on_hit
	proj.speed = current_stats.speed
	proj.damage = current_stats.damage
	proj.global_position = spawn_pos if spawn_pos != Vector2.INF else player.global_position
	if data.projectile_sprite:
		proj.sprite = data.projectile_sprite
	proj.update_rotation()
	get_tree().current_scene.add_child.call_deferred(proj)
	_live_projectiles.append(proj)
	proj.tree_exited.connect(func(): _live_projectiles.erase(proj))
	return proj
	
func clear_projectiles() -> void:
	print("clearing ", _live_projectiles.size(), " projectiles")
	for p in _live_projectiles.duplicate():
		if is_instance_valid(p):
			p.queue_free()
	_live_projectiles.clear()

func get_nearest_enemy() -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return null
	var nearest: Node2D = enemies[0]
	var best_dist := player.global_position.distance_squared_to(nearest.global_position)
	for e in enemies:
		var d := player.global_position.distance_squared_to(e.global_position)
		if d < best_dist:
			best_dist = d
			nearest = e
	return nearest

func get_camera_world_rect() -> Rect2:
	var cam := player.get_viewport().get_camera_2d()
	var viewport_size := get_viewport().get_visible_rect().size
	var zoom := cam.zoom if cam else Vector2.ONE
	var cam_pos := cam.global_position if cam else player.global_position
	var half_size := (viewport_size / zoom) * 0.5
	return Rect2(cam_pos - half_size, half_size * 2.0)
