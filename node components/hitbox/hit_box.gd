class_name HitBox
extends Area2D

@export_category("Layer & Mask")
@export var coll_mask: int = 1
@export var coll_layer: int = 1


signal entered(area)
signal exited(area)

func _ready() -> void:
	collision_layer = coll_layer
	collision_mask = coll_mask
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	#print(owner.name,"'s hitbox layer: ", collision_layer, ", mask: ", collision_mask)
	
func _on_area_entered(area: Area2D) -> void:
	entered.emit(area)
	print("hitbox entered")

func _on_area_exited(area: Area2D) -> void:
	exited.emit(area)
	print("hitbox exited")
