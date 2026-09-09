class_name Projectile
extends Area2D

@onready var proj_sprite: Sprite2D = $ProjSprite

var controller: SpellController
var movement: MovementStrategy
var on_hit: OnHitStrategy

var direction := Vector2.ZERO
var sprite: Texture2D
var lifetime: float = -1.0

var spawn_grace_period: float = 0.0
var has_hit := false

var speed: float
var damage: float = 0.0
var orbit_angle_offset: float = 0.0

var _hit_cooldowns: Dictionary = {}

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if sprite:
		proj_sprite.texture = sprite
	
func _process(delta: float) -> void:
	if movement:
		movement.move(self, delta)
	if spawn_grace_period > 0.0:
		spawn_grace_period -= delta
	#_check_offscreen_cleanup()
	update_rotation()
	_tick_lifetime(delta)
	_tick_hit_cooldowns(delta)
	if not has_hit and on_hit and "tick_interval" in on_hit:
		_check_continuous_overlaps()
	
func _on_area_entered(area: Area2D) -> void:
	if spawn_grace_period > 0.0 or has_hit: return
	_try_hit(area)

func _check_continuous_overlaps()-> void:
	if spawn_grace_period > 0.0:
		return
	for area in get_overlapping_areas():
		_try_hit(area)

func _try_hit(area: Area2D) -> void:
	if has_hit: return
	
	var target = _resolve_enemy(area)
	if not target or not on_hit: return
	
	var id = target.get_instance_id()
	if _hit_cooldowns.has(id): return #hit this enemy (with the id) recently (still on cd)
	
	on_hit.resolve(self, target)
	
	if "tick_interval" in on_hit:
		_hit_cooldowns[id] = on_hit.tick_interval
	else:
		has_hit = true
	
func _tick_hit_cooldowns(delta):
	for id in _hit_cooldowns.keys():
		_hit_cooldowns[id] -= delta
		if _hit_cooldowns[id] <= 0.0:
			_hit_cooldowns.erase(id)

func _resolve_enemy(area: Area2D) -> Node2D:
	if area.is_in_group("enemy"):
		return area
	var parent := area.get_parent()
	if parent and parent.is_in_group("enemy"):
		return parent
	return null

func _check_offscreen_cleanup() -> void:
	var bounds := global.camera_rect_cache.grow(global.camera_rect_bounds)
	if not bounds.has_point(global_position):
		_despawn()

func update_rotation() -> void:
	#if direction != Vector2.ZERO:
		#rotation = direction.angle()
	pass
	
func _despawn():
	var tween = create_tween()
	tween.tween_property(proj_sprite, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
	
func _tick_lifetime(delta: float) -> void:
	if lifetime < 0.0:
		return
	lifetime -= delta
	if lifetime <= 0.0:
		_despawn()
