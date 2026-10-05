extends Node2D

@onready var ground_tile_map_layer: TileMapLayer = $GroundTileMapLayer
@onready var decoration_tile_map_layer: TileMapLayer = $DecorationTileMapLayer

func _ready() -> void:
	place_fake_tiles(100)
	SignalBus.run_over.connect(reset)
	
func place_fake_tiles(fake_tile_diameter: int):
	var fake_tile_radius: int = fake_tile_diameter / 2
	for y in range(-fake_tile_radius,fake_tile_radius):
		for x in range(-fake_tile_radius,fake_tile_radius):
			ground_tile_map_layer.set_cell(Vector2i(x,y), randi_range(1,2), Vector2i(0,0))
	var deco_tile_radius = fake_tile_radius * 2
	for y in range(-deco_tile_radius,deco_tile_radius):
		for x in range(-deco_tile_radius,deco_tile_radius):
			if randf() < .8: continue
			decoration_tile_map_layer.set_cell(Vector2i(x,y), 0, Vector2i(randi_range(0,2), 0))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(global.scenes["main_menu"])
	
func reset():
	for node in get_tree().get_nodes_in_group("enemy"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("projectile"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("pickup"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("experience"):
		node.queue_free()
