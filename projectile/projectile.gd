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

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if sprite:
		proj_sprite.texture = sprite
	
func _process(delta: float) -> void:
	if movement:
		movement.move(self, delta)
	if spawn_grace_period > 0.0:
		spawn_grace_period -= delta
	_check_offscreen_cleanup()
	update_rotation()
	_tick_lifetime(delta)
	
func _on_area_entered(area: Area2D) -> void:
	if spawn_grace_period > 0.0 or has_hit: 
		return
	var target := _resolve_enemy(area)
	if target and on_hit:
		has_hit = true
		on_hit.resolve(self, target)

func _resolve_enemy(area: Area2D) -> Node2D:
	if area.is_in_group("enemy"):
		return area
	var parent := area.get_parent()
	if parent and parent.is_in_group("enemy"):
		return parent
	return null

func _check_offscreen_cleanup() -> void:
	if not controller:
		return
	var rect := controller.get_camera_world_rect()
	var margin := 300.0  # generous buffer so it's well clear before freeing
	var bounds := rect.grow(margin)
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
