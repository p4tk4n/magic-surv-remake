extends Enemy

@onready var health_bar: HealthBar = $HealthBar

func _ready() -> void:
	health_bar.update_health_bar()
