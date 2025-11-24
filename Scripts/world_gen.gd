class_name worldGenerator
extends TileMapLayer

@onready var marker: Node2D = get_node("Marker") # Child Node2D
@onready var selMarker: Node2D = get_node("selectMarker") # Child Node2D

@export var map_width : int = 40
@export var map_height : int = 30
@export var map_res_mult : float = 10.0

@export var map_height_map : FastNoiseLite = null

func is_equal_to_0(number):
	return number == 0
func is_equal_to_1(number):
	return number == 1
func is_equal_to_2(number):
	return number == 2
func isSeedOk():
	if mapArray.filter(is_equal_to_2).size() >= 50 && mapArray.filter(is_equal_to_2).size() <= 100:
		if mapArray.filter(is_equal_to_1).size() >= 250 && mapArray.filter(is_equal_to_1).size() <= 300:
			return true
	else: return false

var mapArray = []
var peakArray = []
var cityArray = []
var mountainArray = []
var plainArray = []

func generate_map() -> void:
	var tile_map_tile_count : int = tile_set.get_source(0).get_tiles_count()-1
	
	clean_terrain_map()
	$"../forestLayer".clear()
	$"../forest2Layer".clear()
	$"../forest3Layer".clear()
	$"../peaksLayer".clear()
	$"../cityLayer".clear()
	set_up_map_height_map()
	mapArray.clear()
	peakArray.clear()
	cityArray.clear()
	mountainArray.clear()
	plainArray.clear()
	
	for x in map_width:
		for y in map_height:
			var random_height_value = abs(roundi(map_height_map.get_noise_2d(x,y) * map_res_mult))
			
			if random_height_value > tile_map_tile_count:
				random_height_value = tile_map_tile_count
			
			mapArray.append(random_height_value)
			
			$".".set_cell (Vector2i(x,y), 1, Vector2i(random_height_value,0), 0)
			if (random_height_value==1):
				randomize()
				if randi()%2==0:
					if randi()%2==1:
						$"../forestLayer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
				randomize()
				if randi()%2==1:
					if randi()%2==0:
						$"../forest2Layer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
				randomize()
				if randi()%2==0:
					if randi()%2==1:
						$"../forest3Layer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
			elif (random_height_value==2):
				randomize()
				var randomNumber = randi()%10
				if (randomNumber)==5:
					var peakList = [x,y]
					peakArray.append(peakList)
	if !isSeedOk():
		generate_map()
	else:
		for x in map_width:
			for y in map_height:
				if get_is_mountain(Vector2i(x,y)) && (x>2 && x<map_width-2) && (y>2 && y<map_height-2):
					var mountainList = [x,y]
					mountainArray.append(mountainList)
				if get_is_plain(Vector2i(x,y)) && (x>2 && x<map_width-2) && (y>2 && y<map_height-2):
					var plainList = [x,y]
					plainArray.append(plainList)
		for peak in peakArray:
			var numberOfTiles = (randi()%4)+1
			var x = peak[0]
			var y = peak[1]
			while numberOfTiles!=0:
							if (!get_is_peak(Vector2i(x,y))):
								$"../peaksLayer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
								numberOfTiles-=1
							else:
								var randomArray = [0,1,2,3,4,5]
								randomArray.shuffle()
								for randomDirection in randomArray:
									if numberOfTiles <= 0:
										break
									else:
										match randomDirection:
											0:
												if get_is_mountain(Vector2i(x,y+1)):
													if (!get_is_peak(Vector2i(x,y+1))):
														if (!get_is_city(Vector2i(x,y+1))):
															$"../peaksLayer".set_cell (Vector2i(x,y+1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
											1: 
												if get_is_mountain(Vector2i(x,y-1)): 
													if (!get_is_peak(Vector2i(x,y-1))):
														if (!get_is_city(Vector2i(x,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x,y-1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
											2:
												if get_is_mountain(Vector2i(x+1,y+1)):
													if (!get_is_peak(Vector2i(x+1,y+1))):
														if (!get_is_city(Vector2i(x+1,y+1))):
															$"../peaksLayer".set_cell (Vector2i(x+1,y+1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
											3: 
												if get_is_mountain(Vector2i(x-1, y+1)): 
													if (!get_is_peak(Vector2i(x-1,y+1))):
														if (!get_is_city(Vector2i(x-1,y+1))):
															$"../peaksLayer".set_cell (Vector2i(x-1,y+1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
											4: 
												if get_is_mountain(Vector2i(x+1, y-1)):
													if (!get_is_peak(Vector2i(x+1,y-1))):
														if (!get_is_city(Vector2i(x+1,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x+1,y-1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
											5: 
												if get_is_mountain(Vector2i(x-1, y-1)):
													if (!get_is_peak(Vector2i(x-1,y-1))): 
														if (!get_is_city(Vector2i(x-1,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x-1,y-1), 0, Vector2i(0,0), 2)
															numberOfTiles-=1
										if randomDirection == randomArray[5]:
											numberOfTiles=0
		generate_Mountain_city()
		generate_Plain_city()

func generate_Mountain_city() -> void:
	randomize()
	var citiesCreated = 0
	while !citiesCreated:
		var randomCity = randi()%mountainArray.size()
		if !get_is_peak(Vector2i(mountainArray[randomCity][0],mountainArray[randomCity][1])) && !citiesCreated:
			var mountainList = [mountainArray[randomCity][0],mountainArray[randomCity][1]]
			$"../cityLayer".set_cell (Vector2i(mountainArray[randomCity][0], mountainArray[randomCity][1]), 0, Vector2i(0,0), 1)
			citiesCreated+=1
			print("x", mountainArray[randomCity][0], "y", mountainArray[randomCity][1])
			cityArray.append(mountainList)
#func generate_river() -> void:
	#pass

func generate_Plain_city() -> void:
	randomize()
	var citiesCreated = 0
	var spawnOk = 0
	while !citiesCreated:
		var randomCity = randi()%plainArray.size()
		for city in cityArray:
			if abs(city[0]-plainArray[randomCity][0])>=3 && abs(city[1]-plainArray[randomCity][1])>=3:
				spawnOk = 1
		if spawnOk:
			if !get_is_city(Vector2i(plainArray[randomCity][0],plainArray[randomCity][1])) && !citiesCreated:
				var plainList = [plainArray[randomCity][0],plainArray[randomCity][1]]
				$"../cityLayer".set_cell (Vector2i(plainArray[randomCity][0], plainArray[randomCity][1]), 0, Vector2i(0,0), 1)
				citiesCreated+=1
				print("xP", plainArray[randomCity][0], "yP", plainArray[randomCity][1])
				cityArray.append(plainList)
				spawnOk = 0

func set_up_map_height_map() -> void:
	randomize()
	map_height_map.seed = randi()

func clean_terrain_map() -> void:
	tile_map_data.clear()

func _physics_process(_delta):
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = to_local(mouse_pos_global)
	var tile_pos = local_to_map(mouse_pos_local)
	if (get_is_interactable(tile_pos)):
		highlight_hex(tile_pos)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			select_hex(tile_pos)
	else:
		highlight_hex(Vector2i(-2,-2))

func highlight_hex(cellPos: Vector2i):
	marker.position = map_to_local(cellPos)
	
func select_hex(cellPos: Vector2i):
	selMarker.position = map_to_local(cellPos)

func get_is_interactable(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_interactable: float = data.get_custom_data("interactable")
		if is_interactable == 1:
			return true
	return false

func get_is_peak(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilepeak")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_peak: float = data.get_custom_data("isPeak")
		if is_peak == 1:
			return true
	return false
	
func get_is_mountain(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_mountain: float = data.get_custom_data("isMountain")
		if is_mountain == 1:
			return true
	return false
	
func get_is_plain(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_plain: float = data.get_custom_data("isPlain")
		if is_plain == 1:
			return true
	return false

func get_is_city(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilecity")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_city: float = data.get_custom_data("isCity")
		if is_city == 1:
			return true
	return false
