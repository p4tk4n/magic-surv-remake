class_name Enemy
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var xp_scene: PackedScene = preload("res://experience/experience.tscn")
@export var xp_texture: Texture2D

@export var max_health: float = 100.0
@export var xp_mult: float = 1.0
@export var is_elite: bool = false
var current_health: float
var is_dead: bool = false

var hit_interval: float = 1.0
var _hit_timer: float = 0.0
var _touching_player: Node = null

func _ready() -> void:
	current_health = max_health
	var freq_offset = randf_range(-0.002, 0.002)
	sprite_2d.material.set_shader_parameter("burn_texture/noise/frequency", 0.0055 + freq_offset)
	
func _process(delta: float) -> void:
	if not _touching_player: return
		
	_hit_timer -= delta
	if _hit_timer <= 0.0:
		_touching_player.take_damage(global.enemy_damage)
		print("hit player")
		_hit_timer = hit_interval

func _physics_process(delta: float) -> void:
	move_and_slide()

func apply_cycle_scaling(cycle: int, increase_per_cycle: float) -> void:
	var mult := 1.0 + (cycle * increase_per_cycle)
	max_health *= mult
	#print("enemy max health", max_health)
	xp_mult = int(xp_mult * mult)
	current_health = max_health
	# if enemy has a damage/speed stat, scale those here too

func die():
	_spawn_experience()
	var tween = create_tween()
	tween.tween_method(tween_shader, 1.0, 0.0, 0.3)
	tween.tween_callback(queue_free)

func tween_shader(percent):
	sprite_2d.material.set_shader_parameter("percentage", percent)

func _spawn_experience():
	var xp = xp_scene.instantiate()
	if xp_texture: xp.sprite = xp_texture
	xp.global_position = global_position
	xp.xp_mult = xp_mult
	get_tree().current_scene.add_child.call_deferred(xp)
	 
func take_damage(amount):
	if current_health - amount > 0:
		current_health -= amount
	elif not is_dead:
		die()
		is_dead = true
		
func _on_hit_box_entered(area: Variant) -> void:
	if area.owner.is_in_group("player"):
		_touching_player = area.owner
		print("enemy hit player, ",area.owner.name)
		_hit_timer = 0.0
	
func _on_hit_box_exited(area: Variant) -> void:
	_touching_player = null
