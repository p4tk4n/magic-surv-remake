extends Node

@export var pickup_area_coll_shape: CollisionShape2D

func _ready() -> void:
	SignalBus.run_over.connect(reset)
	global.player_stats.stat_changed.connect(_on_stat_changed)
	pickup_area_coll_shape.shape.radius = global.player_stats.stats.get("Pickup Area")
	
func reset():
	global.player_stats = load("res://player/stats.tres")
	#loads default player stats wow
	_apply_pickup_area_radius(global.player_stats.stats.get("Pickup Area"))
	
func _on_stat_changed(stat_name: String, value: float):
	match stat_name:
		"Pickup Area": 
			_apply_pickup_area_radius(value)
			
func _apply_pickup_area_radius(radius):
	pickup_area_coll_shape.shape.radius = radius
