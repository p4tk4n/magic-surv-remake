class_name HealthBar
extends ProgressBar

@export var health_gradient: Gradient
@export var player: Player

var health_bar_style

func _ready() -> void:
	health_bar_style = get_theme_stylebox("fill").duplicate()
	add_theme_stylebox_override("fill", health_bar_style)
	health_bar_style.bg_color = health_to_color(player.current_health, player.max_health)
	
func set_bg_color():
	health_bar_style.bg_color = health_to_color(player.current_health, player.max_health)
	
func update_health_bar():
	value = player.current_health
	health_bar_style.bg_color = health_to_color(player.current_health, player.max_health)
	

func health_to_color(current: float, max: float) -> Color:
	var pct: float = clamp(current/max, 0.0, 1.0)
	return health_gradient.sample(pct)
