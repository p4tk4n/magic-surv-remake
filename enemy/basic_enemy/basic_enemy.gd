extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var base_health: float = 100.0
var current_health: float
var is_dead: bool = false

var is_elite: bool = false

var xp_mult: float = 1.0

func _ready() -> void:
	current_health = base_health
	var freq_offset = randf_range(-0.002, 0.002)
	sprite_2d.material.set_shader_parameter("burn_texture/noise/frequency", 0.0055 + freq_offset)
	
	if is_elite:
		current_health *= 2
		sprite_2d.modulate = Color.DARK_RED
		xp_mult = global.elite_xp_mult
		
func _physics_process(delta: float) -> void:
	move_and_slide()

func apply_cycle_scaling(cycle: int, increase_per_cycle: float) -> void:
	var mult := 1.0 + cycle * increase_per_cycle
	base_health *= mult
	xp_mult = int(xp_mult * mult)
	current_health = base_health
	# if enemy has a damage/speed stat, scale those here too

func die():
	_spawn_experience()
	var tween = create_tween()
	tween.tween_method(tween_shader, 1.0, 0.0, 0.3)
	tween.tween_callback(queue_free)

func tween_shader(percent):
	sprite_2d.material.set_shader_parameter("percentage", percent)

func _spawn_experience():
	var xp = global.xp_scene.instantiate()
	xp.global_position = global_position
	xp.xp_mult = xp_mult
	get_tree().current_scene.add_child.call_deferred(xp)
	
func take_damage(amount):
	if current_health - amount > 0:
		current_health -= amount
	elif not is_dead:
		die()
		is_dead = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		area.owner.take_damage(global.enemy_damage)
