class_name JuicyButton
extends TextureButton

@export var hover_scale: float = 1.08
@export var press_scale: float = 0.95
@export var tween_duration: float = 0.5

@export var has_outline: bool = true
@export var outline_shader: Shader = preload("res://shaders/outline.gdshader")
@export var outline_color: Color = Color.WHITE
@export var outline_width: float = 2.0

var _is_mobile: bool = false

func _ready() -> void:
	pivot_offset = size / 2.0
	_is_mobile = OS.has_feature("mobile")
	if has_outline:
		var mat := ShaderMaterial.new()
		mat.shader = outline_shader
		mat.set_shader_parameter("outline_color", outline_color)
		mat.set_shader_parameter("outline_width", outline_width)
		mat.set_shader_parameter("enabled", false)
		material = mat

	if not _is_mobile:
		mouse_entered.connect(_on_hover)
		mouse_exited.connect(_on_unhover)

	button_down.connect(_on_press)
	button_up.connect(_on_release)

func _on_hover() -> void:
	_animate_to(Vector2.ONE * hover_scale)
	if not has_outline: return
	material.set_shader_parameter("enabled", true)
	
func _on_unhover() -> void:
	_animate_to(Vector2.ONE)
	if not has_outline: return
	material.set_shader_parameter("enabled", false)

func _on_press() -> void:
	_animate_to(Vector2.ONE * press_scale)
	if not has_outline: return
	material.set_shader_parameter("enabled", true)
	
func _on_release() -> void:
	var release_scale := Vector2.ONE * hover_scale if not _is_mobile else Vector2.ONE
	_animate_to(release_scale)
	if not has_outline: return
	material.set_shader_parameter("enabled", false)

func _animate_to(target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, tween_duration)
