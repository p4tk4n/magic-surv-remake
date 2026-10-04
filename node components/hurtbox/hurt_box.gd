class_name HurtBox
extends Area2D

@export_category("Layer & Mask")
@export var coll_mask: int = 1
@export var coll_layer: int = 1

signal entered(area)
signal exited(area)

func _ready() -> void:
	collision_layer = coll_layer
	collision_mask = coll_mask
