extends Enemy

@onready var health_bar: HealthBar = $HealthBar

@export var health_manager: EnemyHealthManager

func _ready() -> void:
	health_bar.min_value = 0
	health_bar.max_value = health_manager.max_health
	health_bar.value = health_manager.current_health
	
func take_damage(amount):
	#if current_health - amount > 0:
		#current_health -= amount
	#elif not is_dead:
		#die()
		#is_dead = true
	health_bar.update_health_bar()
