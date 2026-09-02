extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var base_health: float = 100.0
var current_health: float
var is_dead: bool = false

var is_elite: bool = false


var current_xp_mult: float = 1.0

func _ready() -> void:
	current_health = base_health
	var freq_offset = randf_range(-0.002, 0.002)
	sprite_2d.material.set_shader_parameter("burn_texture/noise/frequency", 0.0055 + freq_offset)
	
	if is_elite:
		current_health *= 2
		sprite_2d.modulate = Color.DARK_RED
		current_xp_mult = global.elite_xp_mult
		
func _physics_process(delta: float) -> void:
	move_and_slide()

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
	get_tree().current_scene.add_child.call_deferred(xp)
	
func take_damage(amount):
	if current_health - amount > 0:
		current_health -= amount
		print("enemy got hit")
	elif not is_dead:
		die()
		is_dead = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		area.owner.take_damage(global.enemy_damage)
