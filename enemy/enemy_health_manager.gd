class_name EnemyHealthManager
extends Node

@export var enemy: CharacterBody2D

@export_category("Health Related")
@export var max_health: float = 100.0
@export var xp_mult: float = 1.0
@export var is_elite: bool = false
@export var health_bar: HealthBar

var current_health: float
var is_dead: bool = false

func _ready() -> void:
	current_health = max_health
	if is_elite:
		health_bar.min_value = 0
		health_bar.max_value = max_health
		health_bar.value = current_health
		health_bar.update_health_bar()
		
func apply_cycle_scaling(cycle: int, increase_per_cycle: float) -> void:
	var mult := 1.0 + (cycle * increase_per_cycle)
	max_health *= mult
	xp_mult = int(xp_mult * mult * global.xp_value_mult)
	current_health = max_health
	# if enemy has a damage/speed stat, scale those here too

func take_damage(amount):
	enemy.flash_hit()
	if current_health - amount > 0:
		current_health -= amount
	elif not is_dead:
		enemy.die()
		is_dead = true
	
	if is_elite:
		health_bar.update_health_bar()
		
		
