class_name PlayerHealthManager
extends Node

@export var player: Player
@export var health_bar: HealthBar

var current_health: float
var max_health: float = global.player_stats.stats["Health"]

func _ready() -> void:
	if not player.is_god or OS.has_feature("mobile"): 
		health_bar.value = current_health 
	else:
		health_bar.value = INF
		current_health = INF
	
func setup():
	current_health = max_health
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.update_health_bar()

func take_damage(amount) -> void:
	SignalBus.shake_screen.emit(1.2, 0.5)
	player.flash_hit()
	current_health -= amount
	health_bar.update_health_bar()
	#_update_health_bar()
	player.red_vignette.material.set_shader_parameter("health_percent", current_health/max_health)
	player._flash_amount = player.hit_vignette_flash_max
	player.red_vignette.set_instance_shader_parameter("flash_amount", player._flash_amount)
	if current_health <= 0:
		player.timer_running = false
		player.die()
