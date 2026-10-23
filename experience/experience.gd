class_name XPOrb
extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var chase_speed: float = 0.0
@export var max_chase_speed: float = 600.0
@export var accel: float = 1000.0
@export var collect_dist: float = 10.0

var target: Player = null
var _chasing: bool = true

var xp_mult: float = 1.0
var sprite: Texture2D

var trail_data: TrailData
var trail

func _ready() -> void:
	sprite_2d.texture = sprite
	
func start_chase(player: Player) -> void:
	target = player
	_chasing = true
	if trail_data:
		trail = ProjectileTrail.new()
		add_child(trail)
		trail.setup(trail_data, self)
	
func _process(delta: float) -> void:
	if not _chasing or not target:
		return
	
	var target_dist := target.global_position - global_position
	var dist = target_dist.length()
	
	if dist <= collect_dist:
		_collect()
		return
	
	chase_speed = min(chase_speed+accel*delta, max_chase_speed)
	global_position += target_dist.normalized() * chase_speed * delta
	
func _collect():
	target.collected_xp.emit(xp_mult)
	queue_free()
