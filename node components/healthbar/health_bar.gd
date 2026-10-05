class_name HealthBar
extends ProgressBar

@export var health_gradient: Gradient
@export var health_manager: Node

var health_bar_style

func _ready() -> void:
	health_bar_style = get_theme_stylebox("fill").duplicate()
	add_theme_stylebox_override("fill", health_bar_style)
	update_health_bar()
	
func set_bg_color():
	health_bar_style.bg_color = health_to_color(health_manager.current_health, health_manager.max_health)
	
func update_health_bar():
	if not health_manager: return
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "value", health_manager.current_health, 0.75)
	health_bar_style.bg_color = health_to_color(health_manager.current_health, health_manager.max_health)

func health_to_color(current: float, max: float) -> Color:
	var pct: float = clamp(current/max, 0.0, 1.0)
	return health_gradient.sample(pct)
