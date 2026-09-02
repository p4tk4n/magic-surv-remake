extends Camera2D

@export var max_offset: float = 16.0
@export var default_duration: float = 0.4  # seconds for a full-intensity shake to settle

var _trauma: float = 0.0
var _current_decay_rate: float = 1.0
var _noise := FastNoiseLite.new()
var _noise_time: float = 0.0

func _ready() -> void:
	SignalBus.shake_screen.connect(_on_shake_screen)
	_noise.seed = randi()
	_noise.frequency = 4.0
	_current_decay_rate = 1.0 / default_duration

func _on_shake_screen(intensity: float = 1.0, duration: float = -1.0) -> void:
	var actual_duration := duration if duration > 0.0 else default_duration
	_trauma = clamp(_trauma + intensity, 0.0, 1.0)
	_current_decay_rate = 1.0 / actual_duration

func _process(delta: float) -> void:
	if _trauma <= 0.0:
		offset = Vector2.ZERO
		return

	_noise_time += delta * 30.0
	var shake_amount := _trauma * _trauma

	var offset_x := _noise.get_noise_2d(_noise_time, 0.0) * max_offset * shake_amount
	var offset_y := _noise.get_noise_2d(0.0, _noise_time) * max_offset * shake_amount

	offset = Vector2(offset_x, offset_y)
	_trauma = max(_trauma - _current_decay_rate * delta, 0.0)
