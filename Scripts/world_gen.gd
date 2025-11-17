class_name worldGenerator
extends TileMapLayer

@export var map_width : int = 10
@export var map_heigth : int = 10
@export var map_res_mult : float = 2.0

func generate_map() -> void:
	for x in map_width:
		for y in map_heigth:
			
			set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
