class_name Player
extends CharacterBody2D

@onready var spell_manager: SpellManager = $SpellManager
@onready var level_manager: Node = $LevelManager
@onready var sprite_2d: Sprite2D = $PickupArea/Sprite2D
@onready var death_screen: NinePatchRect = $UICanvasLayer/DeathScreen
@onready var run_time_label: Label = $UICanvasLayer/DeathScreen/BoxContainer/BoxContainer/time
#@onready var health_bar: ProgressBar = $HealthBar
@onready var virtual_joystick: VirtualJoystick = $UICanvasLayer/UI/MarginContainer/VirtualJoystick
@onready var xp_bar: TextureProgressBar = $UICanvasLayer/UI/TopScreen/XpBar
@onready var red_vignette: TextureRect = $ShaderCanvasLayer/RedVignette
@onready var animation_manager: AnimationManager = $AnimationManager
@onready var health_bar: HealthBar = $AnimatedSprite2D/HealthBar
@onready var time_label: Label = $UICanvasLayer/UI/TimeLabel
@onready var pause_screen: Panel = $UICanvasLayer/UI/PauseScreen

signal collected_xp(mult)

var default_move_speed: float = global.player_stats.stats["base_move_speed"]
var current_health: float
var max_health: float = global.player_stats.stats["base_health"]
@export var hit_vignette_flash_max: float = 0.5
@export var hit_vignette_flash_decay: float = 2.0
var _flash_amount: float = 0.0

var elapsed_run_time: float = 0.0
var timer_running: bool = true

var health_bar_style: StyleBoxFlat
var is_dead: bool = false

var is_god: bool = false

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
	health_bar.update_health_bar()
	
	if not is_god or OS.has_feature("mobile"): 
		health_bar.value = current_health 
	else:
		health_bar.value = INF
		current_health = INF
	
	time_label.text = format_time(elapsed_run_time)

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
	
func _physics_process(delta: float) -> void:
	if not is_dead and not get_tree().paused: movement(delta)

func _process(delta: float) -> void:
	if starting: _starting_timer(delta)
	if starting: return
	if not get_tree().paused and timer_running:
		elapsed_run_time += delta
	if _flash_amount > 0.0:
		_flash_amount = max(_flash_amount - hit_vignette_flash_decay * delta, 0.0)
		red_vignette.material.set_shader_parameter("flash_amount", _flash_amount)
	
	time_label.text = format_time(elapsed_run_time)
	
func movement(delta):
	var dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	animation_manager.update_sprite_animation(dir)
	if dir:
		velocity = dir.normalized() * default_move_speed * delta
	else:
		velocity = Vector2.ZERO
		
	position += velocity

	move_and_slide()

func take_damage(amount) -> void:
	print("took damage")
	SignalBus.shake_screen.emit(1.2, 0.5)
	current_health -= amount
	health_bar.update_health_bar()
	#_update_health_bar()
	red_vignette.material.set_shader_parameter("health_percent", current_health/max_health)
	_flash_amount = hit_vignette_flash_max
	red_vignette.set_instance_shader_parameter("flash_amount", _flash_amount)
	if current_health <= 0:
		timer_running = false
		die()
	
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

func reset():
	global.player_xp = 0
	spell_manager.reset()
	elapsed_run_time = 0.0
	timer_running = true
	current_health = max_health
	global_position = Vector2.ZERO
	velocity = Vector2.ZERO
	is_dead = false
	global.unavailable_upgrades = []
	health_bar.update_health_bar()
	red_vignette.set_instance_shader_parameter("flash_amount", 0)
	red_vignette.material.set_shader_parameter("health_percent", 1.0)
	
func _start_new_run():
	reset()
	SignalBus.run_over.emit()
	get_tree().paused = false
	death_screen.visible = false
	_add_starting_spell()
	
func _on_button_pressed() -> void:
	_start_new_run()

func _on_pause_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	pause_screen.visible = get_tree().paused
