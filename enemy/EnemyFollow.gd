extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed: float = 100.0
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("player")

func PhysicsUpdate(delta: float):
	if not player or not enemy:
		return
	
	var dir_to_player = player.global_position - enemy.global_position 
	enemy.velocity = dir_to_player.normalized() * move_speed

		
		
	
	
