extends Enemy

@onready var health_bar: HealthBar = $HealthBar

func _ready() -> void:
	current_health = max_health
	var freq_offset = randf_range(-0.002, 0.002)
	sprite_2d.material.set_shader_parameter("burn_texture/noise/frequency", 0.0055 + freq_offset)
	
	health_bar.min_value = 0
	health_bar.max_value = max_health
	health_bar.value = current_health
	
func take_damage(amount):
	if current_health - amount > 0:
		current_health -= amount
	elif not is_dead:
		die()
		is_dead = true
	health_bar.update_health_bar()
