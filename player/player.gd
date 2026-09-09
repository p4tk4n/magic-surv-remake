class_name Player
extends CharacterBody2D

@onready var spell_manager: SpellManager = $SpellManager
@onready var level_manager: Node = $LevelManager
@onready var xp_bar: ProgressBar = $UICanvasLayer/UI/XpBar
@onready var sprite_2d: Sprite2D = $PickupArea/Sprite2D
@onready var death_screen: Panel = $UICanvasLayer/DeathScreen
@onready var run_time_label: Label = $UICanvasLayer/DeathScreen/BoxContainer/BoxContainer/time
@onready var health_bar: ProgressBar = $HealthBar
@onready var virtual_joystick: VirtualJoystick = $UICanvasLayer/UI/MarginContainer/VirtualJoystick

@export var health_gradient: Gradient

var default_move_speed: float = global.player_stats.stats["base_move_speed"]
var current_health: float
var max_health: float = global.player_stats.stats["base_health"]

var elapsed_run_time: float = 0.0
var timer_running: bool = true

signal collected_xp(mult)
var health_bar_style: StyleBoxFlat
var is_dead: bool = false

var is_god: bool = true

var starting: bool = false
var start_timer_delay: float = 3.0
var current_start_timer: float = 0.0

func _ready() -> void:
	starting = true
	get_tree().paused = true
	
	_add_starting_spell()
	collected_xp.connect(level_manager.progress_xp_bar)
	current_health = max_health
	
	health_bar.min_value = 0
	health_bar.max_value = max_health
	if not is_god or OS.has_feature("mobile"): 
		health_bar.value = current_health 
	else:
		health_bar.value = INF
		current_health = INF
	
	health_bar_style = health_bar.get_theme_stylebox("fill")
	health_bar_style.bg_color = health_to_color(current_health, max_health)

func _starting_timer(delta):
	if current_start_timer < start_timer_delay:
		current_start_timer += delta
	else:
		current_start_timer = 0.0
		get_tree().paused = false
		starting = false
	
func _add_starting_spell():
	var starting_spell: SpellData = load("res://spells/resources/magic_bolt/magic_bolt.tres")
	spell_manager.add_spell(starting_spell)
	print(spell_manager.active_spells)
func _physics_process(delta: float) -> void:
	if not is_dead and not get_tree().paused: movement(delta)

func _process(delta: float) -> void:
	if starting: _starting_timer(delta)
	if starting: return
	if not get_tree().paused and timer_running:
		elapsed_run_time += delta
		
func movement(delta):
	var dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if dir:
		velocity = dir.normalized() * default_move_speed * delta
	else:
		velocity = Vector2.ZERO
		
	position += velocity

	move_and_slide()

func take_damage(amount) -> void:
	SignalBus.shake_screen.emit(0.8, 0.5)
	current_health -= amount
	health_bar.value = current_health
	health_bar_style.bg_color = health_to_color(current_health, max_health)
	
	if current_health <= 0:
		timer_running = false
		die()

func _update_health_bar() -> void:
	health_bar.value = current_health
	health_bar_style.bg_color = health_to_color(current_health, max_health)
	
func die():
	var tween = create_tween()
	tween.tween_method(tween_shader, 1.0, 0.0, 0.5)
	get_tree().paused = true
	death_screen.visible = true
	run_time_label.text = format_time(elapsed_run_time)
	is_dead = true
	
func format_time(seconds: float) -> String:
	var total_sec := int(seconds)
	var mins := total_sec / 60
	var secs := total_sec % 60
	return "%02d:%02d" % [mins, secs]
	
func tween_shader(object, percent):
	object.material.set_shader_parameter("percentage", percent)

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is XPOrb:
		area.start_chase(self)
		
func _on_xp_bar_value_changed(value: float) -> void:
	if xp_bar.value >=  xp_bar.max_value:
		level_manager.level_up_player()

func health_to_color(current: float, max: float) -> Color:
	var pct: float = clamp(current/max, 0.0, 1.0)
	return health_gradient.sample(pct)
	
func _start_new_run():
	global.player_xp = 0
	SignalBus.run_over.emit()
	spell_manager.reset()
	elapsed_run_time = 0.0
	timer_running = true
	current_health = max_health
	global_position = Vector2.ZERO
	velocity = Vector2.ZERO
	is_dead = false
	get_tree().paused = false
	
	global.unavailable_upgrades = []
	_update_health_bar()
	death_screen.visible = false
	_add_starting_spell()
	
func _on_button_pressed() -> void:
	_start_new_run()
