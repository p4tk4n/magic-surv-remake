class_name AnimationManager
extends Node

@export var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("idle")

func update_sprite_animation(player_dir: Vector2):
	if not player_dir: animated_sprite.play("idle")
	elif player_dir.x > 0 and player_dir.y == 0: animated_sprite.play("move_right")
	elif player_dir.x < 0 and player_dir.y == 0: animated_sprite.play("move_left")
	
	elif player_dir.x < 0 and player_dir.y > 0: animated_sprite.play("move_lowerleft")
	elif player_dir.x < 0 and player_dir.y < 0: animated_sprite.play("move_upperleft")
	
	elif player_dir.x > 0 and player_dir.y > 0: animated_sprite.play("move_lowerright")
	elif player_dir.x > 0 and player_dir.y < 0: animated_sprite.play("move_upperright")
