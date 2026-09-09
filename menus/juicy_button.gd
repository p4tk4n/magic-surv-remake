class_name JuicyButton
extends TextureButton

@export var hover_scale: float = 1.08
@export var press_scale: float = 0.95
@export var tween_duration: float = 0.12

func _ready() -> void:
	pivot_offset = size / 2.0   # scale from center, not top-left corner
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	button_down.connect(_on_press)
	button_up.connect(_on_release)

func _on_hover() -> void:
	_animate_to(Vector2.ONE * hover_scale)

func _on_unhover() -> void:
	_animate_to(Vector2.ONE)

func _on_press() -> void:
	_animate_to(Vector2.ONE * press_scale)

func _on_release() -> void:
	_animate_to(Vector2.ONE * hover_scale)  # snaps back to hover size, not base — feels responsive

func _animate_to(target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, tween_duration)
