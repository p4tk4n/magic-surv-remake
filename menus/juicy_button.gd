class_name JuicyButton
extends TextureButton

@export var hover_scale: float = 1.08
@export var press_scale: float = 0.95
@export var tween_duration: float = 0.12

@export var outline_shader: Shader = preload("res://shaders/outline.gdshader")
@export var outline_color: Color = Color.WHITE
@export var outline_width: float = 2.0

func _ready() -> void:
	pivot_offset = size / 2.0   # scale from center, not top-left corner
	
	var mat := ShaderMaterial.new()
	mat.shader = outline_shader
	mat.set_shader_parameter("outline_color", outline_color)
	mat.set_shader_parameter("outline_width", outline_width)
	mat.set_shader_parameter("enabled", false)
	material = mat
	
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	button_down.connect(_on_press)
	button_up.connect(_on_release)

func _on_hover() -> void:
	if not OS.has_feature("mobile"): material.set_shader_parameter("enabled", true)
	_animate_to(Vector2.ONE * hover_scale)

func _on_unhover() -> void:
	if not OS.has_feature("mobile"): material.set_shader_parameter("enabled", false)
	_animate_to(Vector2.ONE)

func _on_press() -> void:
	material.set_shader_parameter("enabled", true)
	_animate_to(Vector2.ONE * press_scale)

func _on_release() -> void:
	material.set_shader_parameter("enabled", false)
	_animate_to(Vector2.ONE * hover_scale)  # snaps back to hover size, not base — feels responsive

func _animate_to(target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, tween_duration)
