class_name Player
extends CharacterBody2D

var default_move_speed: float = 220.0
@onready var spell_manager: SpellManager = $SpellManager
@onready var level_manager: Node = $LevelManager
@onready var xp_bar: ProgressBar = $UICanvasLayer/UI/XpBar

signal collected_xp

func _ready() -> void:
	var mb_data: SpellData = load("res://spells/resources/magic_bolt/magic_bolt.tres")
	spell_manager.add_spell(mb_data)
	collected_xp.connect(level_manager.progress_xp_bar)
	
func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta):
	var dir_x = Input.get_axis("player_left","player_right")
	var dir_y = Input.get_axis("player_up", "player_down")
	
	if dir_x or dir_y:
		velocity = Vector2(dir_x, dir_y).normalized() * default_move_speed * delta
	else:
		velocity = Vector2.ZERO
		
	position += velocity
	
	move_and_slide()

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is XPOrb:
		area.start_chase(get_tree().get_first_node_in_group("player"))
		
func _on_xp_bar_value_changed(value: float) -> void:
	if xp_bar.value >=  xp_bar.max_value:
		level_manager.level_up_player()
		
