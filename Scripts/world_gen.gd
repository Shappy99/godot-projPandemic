class_name worldGenerator
extends TileMapLayer

@export var map_width : int = 40
@export var map_height : int = 30
@export var map_res_mult : float = 10.0

@export var map_height_map : FastNoiseLite = null

func generate_map() -> void:
	var tile_map_tile_count : int = tile_set.get_source(0).get_tiles_count()-1
	
	clean_terrain_map()
	set_up_map_height_map()
	
	for x in map_width:
		for y in map_height:
			var random_height_value = abs(roundi(map_height_map.get_noise_2d(x,y) * map_res_mult))
			
			if random_height_value > tile_map_tile_count:
				random_height_value = tile_map_tile_count
			
			print(str(random_height_value))
			
			set_cell (Vector2i(x-1,y-1), 2, Vector2i(random_height_value,0), 0)

func set_up_map_height_map() -> void:
	randomize()
	map_height_map.seed = randi()

func clean_terrain_map() -> void:
	tile_map_data.clear()

func _physics_process(_delta):
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = to_local(mouse_pos_global)
	var tile_pos = local_to_map(mouse_pos_local)
	print(tile_pos)
