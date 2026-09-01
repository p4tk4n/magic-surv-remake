class_name EnemyManager
extends Node

@export var player: Player

var enemy_scene: PackedScene = preload("res://enemy/enemy.tscn")

var current_wave: int = 0
var enemies_in_wave: int = 10
var next_wave_timer_max: float = 5.0
var next_wave_timer: float = 0.0

func _ready() -> void:
	spawn_wave()

func _process(delta: float) -> void:
	if next_wave_timer >= next_wave_timer_max:
		spawn_wave()
		next_wave_timer = 0.0
	else:
		next_wave_timer += delta

func spawn_wave():
	for i in range(enemies_in_wave):
		var enemy = enemy_scene.instantiate()
		var random_spawn_offset = Vector2(
			randi_range(-10,10),
			randi_range(-10,10)
		)
		enemy.global_position = random_circle_point(player.global_position, 500) + random_spawn_offset
		add_child(enemy)
	
func random_circle_point(center: Vector2, radius: float) -> Vector2:
	var angle: float = randf_range(0.0, 2.0 * PI)
	return center + Vector2(
		cos(angle) * radius,
		sin(angle) * radius
	)
