extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	place_fake_tiles(100)

func place_fake_tiles(fake_tile_diameter: int):
	var fake_tile_radius: int = fake_tile_diameter / 2
	for y in range(-fake_tile_radius,fake_tile_radius):
		for x in range(-fake_tile_radius,fake_tile_radius):
			tile_map_layer.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
