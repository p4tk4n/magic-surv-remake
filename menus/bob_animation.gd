class_name BobAnimation
extends Node

@export var target: Control
@export var amplitude: float = 8.0
@export var speed: float = 2.0

var _base_y: float
var _time: float = 0.0

func _ready() -> void:
	_base_y = target.position.y

func _process(delta: float) -> void:
	_time += delta * speed
	target.position.y = _base_y + sin(_time) * amplitude
