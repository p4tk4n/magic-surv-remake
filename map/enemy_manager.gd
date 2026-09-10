class_name EnemyManager
extends Node

@export var player: Player

@export_category("Enemy Types")
@export var enemy_types: Array[EnemyTypeData] = []

@export_category("Base")
@export var base_enemies_in_wave: int = 6
@export var next_wave_timer_max: float = 5.0
@export var enemy_amount_increase: float = 1.3
@export var max_enemies_alive: int = 150

var enemies_in_wave: int
var next_wave_timer: float = 0.0
var current_wave: int = 0

@export_category("Boss waves")
@export var waves_per_boss_wave: int = 5
@export var boss_wave_mult: float = 1.5

@export_category("Type Cycling")
@export var stat_increase_per_cycle: float = 0.15  # +15% enemy stats per full cycle through all types

var current_type_index: int = 0
var type_timer: float = 0.0
var cycle_count: int = 0

func _ready() -> void:
	enemies_in_wave = base_enemies_in_wave
	spawn_wave()
	SignalBus.run_over.connect(reset)

func _process(delta: float) -> void:
	next_wave_timer += delta
	if next_wave_timer >= next_wave_timer_max:
		next_wave_timer = 0.0
		spawn_wave()

	if enemy_types.size() > 1:
		type_timer += delta
		if type_timer >= enemy_types[current_type_index].duration:
			type_timer = 0.0
			_advance_type()

func _advance_type() -> void:
	current_type_index += 1
	if current_type_index >= enemy_types.size():
		current_type_index = 0
		cycle_count += 1

func reset() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

	current_wave = 0
	next_wave_timer = 0.0
	current_type_index = 0
	type_timer = 0.0
	cycle_count = 0
	enemies_in_wave = base_enemies_in_wave

	spawn_wave()

func spawn_wave() -> void:
	current_wave += 1

	var current_alive := get_tree().get_nodes_in_group("enemy").size()
	if current_alive >= max_enemies_alive:
		return  # battlefield's full, skip this wave rather than piling on

	var is_boss_wave := current_wave % waves_per_boss_wave == 0
	if is_boss_wave:
		enemies_in_wave = int(enemies_in_wave * enemy_amount_increase)

	var spawn_count := enemies_in_wave
	if is_boss_wave:
		spawn_count = int(spawn_count * boss_wave_mult)

	spawn_count = min(spawn_count, max_enemies_alive - current_alive)

	var scene_to_use := _get_current_enemy_scene()

	for i in spawn_count:
		var enemy = scene_to_use.instantiate()
		var random_spawn_offset = Vector2(randi_range(-50, 50), randi_range(-50, 50))
		enemy.global_position = random_circle_point(player.global_position, 500) + random_spawn_offset
		if enemy.has_method("apply_cycle_scaling"):
			enemy.apply_cycle_scaling(cycle_count, stat_increase_per_cycle)
		add_child(enemy)

func _get_current_enemy_scene() -> PackedScene:
	return enemy_types[current_type_index].enemy_scene

func random_circle_point(center: Vector2, radius: float) -> Vector2:
	var angle: float = randf_range(0.0, 2.0 * PI)
	return center + Vector2(cos(angle) * radius, sin(angle) * radius)
