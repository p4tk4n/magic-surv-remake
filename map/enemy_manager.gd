class_name EnemyManager
extends Node

@export var player: Player

var enemy_scene: PackedScene = preload("res://enemy/enemy.tscn")

var current_wave: int = 0
var enemies_in_wave: int = 6
var next_wave_timer_max: float = 5.0
var next_wave_timer: float = 0.0

var extra_wave: bool = true
var extra_enemies_mult: float = 1.5

func _ready() -> void:
	spawn_wave()
	SignalBus.run_over.connect(reset)
	
func _process(delta: float) -> void:
	if next_wave_timer >= next_wave_timer_max:
		spawn_wave()
		next_wave_timer = 0.0
	else:
		next_wave_timer += delta

func reset():
	for child in get_children():
		child.queue_free()
	
	current_wave = 0
	next_wave_timer = 0.0
	
	spawn_wave()
	
func spawn_wave():
	current_wave += 1
	if current_wave % 5 == 0:
		extra_wave = true
	
	for i in range(int(enemies_in_wave * extra_enemies_mult)):
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
