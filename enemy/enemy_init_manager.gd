class_name EnemyInitManager
extends Node

@export var enemy: CharacterBody2D

func setup():
	enemy.hit_box.area_entered.connect(enemy._hit_box_entered)
	enemy.hit_box.area_exited.connect(enemy._hit_box_exited)
	enemy.sprite_2d.material.set_shader_parameter("burn_texture/noise/frequency", 0.0055)
