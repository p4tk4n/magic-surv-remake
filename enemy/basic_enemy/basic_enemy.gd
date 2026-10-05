class_name Enemy
extends CharacterBody2D

@onready var enemy_init_manager: EnemyInitManager = $EnemyInitManager
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var xp_scene: PackedScene = preload("res://experience/experience.tscn")
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@export var xp_texture: Texture2D
@onready var health_manager: EnemyHealthManager = $EnemyHealthManager

var hit_interval: float = 1.0
var _hit_timer: float = 0.0
var _touching_player: Node = null

func _ready() -> void:
	enemy_init_manager.setup()
	sprite_2d.play("default")
	
func _process(delta: float) -> void:
	if not _touching_player: return
		
	_hit_timer -= delta
	if _hit_timer <= 0.0:
		_touching_player.health_manager.take_damage(global.enemy_damage)
		_hit_timer = hit_interval
	sprite_2d.rotation += deg_to_rad(delta * 100)
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func take_damage(damage: float):
	health_manager.take_damage(damage)

func die():
	_spawn_experience()
	var tween = create_tween()
	tween.tween_method(tween_shader, 1.0, 0.0, 0.3)
	tween.tween_callback(queue_free)

func tween_shader(percent):
	sprite_2d.material.set_shader_parameter("percentage", percent)

func flash_hit():
	var tween := create_tween()
	tween.tween_property(sprite_2d.material, "shader_parameter/flash_amount", 0.5, 0.0)
	tween.tween_property(sprite_2d.material, "shader_parameter/flash_amount", 0.0, 0.2)
	
func _spawn_experience():
	var xp = xp_scene.instantiate()
	if xp_texture: xp.sprite = xp_texture
	xp.global_position = global_position
	xp.xp_mult = health_manager.xp_mult
	get_tree().current_scene.add_child.call_deferred(xp)
	 
func _hit_box_entered(area: Variant) -> void:
	if area.owner.is_in_group("player"):
		_touching_player = area.owner
		_hit_timer = 0.0
	
func _hit_box_exited(area: Variant) -> void:
	_touching_player = null
