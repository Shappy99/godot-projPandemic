class_name worldGenerator
extends TileMapLayer

@onready var marker: Node2D = get_node("Marker") # Child Node2D
@onready var selMarker: Node2D = get_node("selectMarker") # Child Node2D

@export var map_width : int = 28
@export var map_height : int = 18
@export var map_res_mult : float = 10.0

@export var map_height_map : FastNoiseLite = null

func is_equal_to_0(number):
	return number == 0
func is_equal_to_1(number):
	return number == 1
func is_equal_to_2(number):
	return number == 2
func isSeedOk(): ## make it percentage rather than fixed number of tiles
	if mapArray.filter(is_equal_to_2).size() >= 50 && mapArray.filter(is_equal_to_2).size() <= 100:
		if mapArray.filter(is_equal_to_1).size() >= 250 && mapArray.filter(is_equal_to_1).size() <= 300:
			return true
	else: return false

var mapArray = []
var peakArray = []
var cityArray = []
var mountainArray = []
var plainArray = []
var riversArray = []

func clear_all_layers() -> void:
	$"../forestLayer".clear()
	$"../forest2Layer".clear()
	$"../forest3Layer".clear()
	$"../peaksLayer".clear()
	$"../cityLayer".clear()
	$"../water".clear()
	$"../quake".clear()
	$"../tsunami".clear()
	$"../fire".clear()
	$"../tornado".clear()
	$"../countries".clear()
	$"../river".clear()

func clear_all_arrays() -> void:
	mapArray.clear()
	peakArray.clear()
	cityArray.clear()
	mountainArray.clear()
	plainArray.clear()
	riversArray.clear()

func generate_map() -> void:
	var tile_map_tile_count : int = tile_set.get_source(1).get_tiles_count()-1
	clear_all_layers()
	clean_terrain_map()
	clear_all_arrays()
	set_up_map_height_map()

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
								$"../peaksLayer".set_cell (Vector2i(x,y), 2, Vector2i(0,0), 0)
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
															$"../peaksLayer".set_cell (Vector2i(x,y+1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
											1: 
												if get_is_mountain(Vector2i(x,y-1)): 
													if (!get_is_peak(Vector2i(x,y-1))):
														if (!get_is_city(Vector2i(x,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x,y-1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
											2:
												if get_is_mountain(Vector2i(x+1,y+1)):
													if (!get_is_peak(Vector2i(x+1,y+1))):
														if (!get_is_city(Vector2i(x+1,y+1))):
															$"../peaksLayer".set_cell (Vector2i(x+1,y+1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
											3: 
												if get_is_mountain(Vector2i(x-1, y+1)): 
													if (!get_is_peak(Vector2i(x-1,y+1))):
														if (!get_is_city(Vector2i(x-1,y+1))):
															$"../peaksLayer".set_cell (Vector2i(x-1,y+1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
											4: 
												if get_is_mountain(Vector2i(x+1, y-1)):
													if (!get_is_peak(Vector2i(x+1,y-1))):
														if (!get_is_city(Vector2i(x+1,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x+1,y-1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
											5: 
												if get_is_mountain(Vector2i(x-1, y-1)):
													if (!get_is_peak(Vector2i(x-1,y-1))): 
														if (!get_is_city(Vector2i(x-1,y-1))):
															$"../peaksLayer".set_cell (Vector2i(x-1,y-1), randi()%2, Vector2i(0,0), 0)
															numberOfTiles-=1
										if randomDirection == randomArray[5]:
											numberOfTiles=0
		#generate_Mountain_city()
		#generate_Plain_city()
		#generate_Plain_city()
	pass

func generate_Mountain_city(cityNumber) -> void:
	randomize()
	var spawnable = 0
	mountainArray.shuffle()
	var cityLocation = Vector2i.ZERO
	for i in mountainArray:
		if cityLocation == Vector2i.ZERO:
			if get_country_number(Vector2i(i[0],i[1]))==cityNumber:
				spawnable = 1
				cityLocation = Vector2i(i[0],i[1])
	if spawnable == 1:
		if get_country_number(cityLocation)==cityNumber:
			if !get_is_peak(cityLocation):
				if !get_is_city(cityLocation):
					$"../cityLayer".set_cell (cityLocation, 0, Vector2i(0,0), 1)

func generate_Plain_city(cityNumber) -> void:
	randomize()
	var spawnable = 0
	plainArray.shuffle()
	var cityLocation = Vector2i.ZERO
	for i in plainArray:
		if cityLocation == Vector2i.ZERO:
			if get_country_number(Vector2i(i[0],i[1]))==cityNumber:
				spawnable = 1
				cityLocation = Vector2i(i[0],i[1])
	if spawnable == 1:
		if get_country_number(cityLocation)==cityNumber:
			if !get_is_city(cityLocation):
				$"../cityLayer".set_cell (cityLocation, 0, Vector2i(0,0), 1)

func generate_River_city(cityNumber) -> void:
	randomize()
	var spawnable = 0
	riversArray.shuffle()
	var cityLocation = Vector2i.ZERO
	for i in riversArray:
		if cityLocation == Vector2i.ZERO:
			if get_country_number(Vector2i(i[0],i[1]))==cityNumber:
				spawnable = 1
				cityLocation = Vector2i(i[0],i[1])
	if spawnable == 1:
		if get_country_number(cityLocation)==cityNumber:
			if !get_is_city(cityLocation):
				$"../cityLayer".set_cell (cityLocation, 0, Vector2i(0,0), 1)

func generate_river(tilePos) -> void:
	randomize()
	var riversCreated = 0
	var head = Vector2i(tilePos[0],tilePos[1])
	while !riversCreated:
		if !get_is_water(head):
			if (!get_is_peak(head)):
				$"../river".set_cell (head, 2, Vector2i(0,0), 1)
				riversArray.append(head)
		var randomRiver = (randi()%2)+(randi()%2)+(randi()%2)+3
		for i in randomRiver-1:
			#$"../river".set_cell (Vector2i(), 0, Vector2i(0,0), 1)
			var randomArray = [0,1,2,3,4,5]
			randomArray.shuffle()
			for randomDirection in randomArray:
				if i <= 0:
					break
				else:
					match randomDirection:
						0:
							if !get_is_water(head+Vector2i(0,1)):
								if (!get_is_peak(head+Vector2i(0,1))):
									if !get_is_river(head+Vector2i(0,1)):
										$"../river".set_cell (head+Vector2i(0,1), 2, Vector2i(0,0), 1)
										riversArray.append(head)
										head+=Vector2i(0,1)
										i=0
						1: 
							if !get_is_water(head+Vector2i(0,-1)): 
								if (!get_is_peak(head+Vector2i(0,-1))):
									if !get_is_river(head+Vector2i(0,-1)): 
										$"../river".set_cell (head+Vector2i(0,-1), 2, Vector2i(0,0), 1)
										riversArray.append(head)
										head+=Vector2i(0,-1)
										i=0
						2:
							if head[0]%2==0:
								if !get_is_water(head+Vector2i(1,-1)):
									if (!get_is_peak(head+Vector2i(1,-1))):
										if !get_is_river(head+Vector2i(1,-1)):
											$"../river".set_cell (head+Vector2i(1,-1), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(1,-1)
											i=0
							else:
								if !get_is_water(head+Vector2i(1,0)):
									if (!get_is_peak(head+Vector2i(1,0))):
										if !get_is_river(head+Vector2i(1,0)):
											$"../river".set_cell (head+Vector2i(1,0), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(1,0)
											i=0
						3: 
							if head[0]%2==0:
								if !get_is_water(head+Vector2i(1,0)): 
									if (!get_is_peak(head+Vector2i(1,0))):
										if !get_is_river(head+Vector2i(1,0)):
											$"../river".set_cell (head+Vector2i(1,0), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(1,0)
											i=0
							else:
								if !get_is_water(head+Vector2i(1,1)): 
									if (!get_is_peak(head+Vector2i(1,1))):
										if !get_is_river(head+Vector2i(1,1)):
											$"../river".set_cell (head+Vector2i(1,1), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(1,1)
											i=0
						4: 
							if head[0]%2==0:
								if !get_is_water(head+Vector2i(-1,0)):
									if (!get_is_peak(head+Vector2i(-1,0))):
										if !get_is_river(head+Vector2i(-1,0)):
											$"../river".set_cell (head+Vector2i(-1,0), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(-1,0)
											i=0
							else:
								if !get_is_water(head+Vector2i(-1,1)):
									if (!get_is_peak(head+Vector2i(-1,1))):
										if !get_is_river(head+Vector2i(-1,1)):
											$"../river".set_cell (head+Vector2i(-1,1), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(-1,1)
											i=0
						5: 
							if head[0]%2==0:
								if !get_is_water(head+Vector2i(-1,-1)):
									if (!get_is_peak(head+Vector2i(-1,-1))): 
										if !get_is_river(head+Vector2i(-1,-1)):
											$"../river".set_cell (head+Vector2i(-1,-1), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(-1,-1)
											i=0
							else:
								if !get_is_water(head+Vector2i(-1,0)):
									if (!get_is_peak(head+Vector2i(-1,0))): 
										if !get_is_river(head+Vector2i(-1,0)):
											$"../river".set_cell (head+Vector2i(-1,0), 2, Vector2i(0,0), 1)
											riversArray.append(head)
											head+=Vector2i(-1,0)
											i=0
					i=0
		riversCreated=1

func set_up_map_height_map() -> void:
	randomize()
	map_height_map.seed = randi()

func clean_terrain_map() -> void:
	tile_map_data.clear()

func _physics_process(_delta):
	#var mouse_pos_global = get_viewport().get_mouse_position() #old
	var mouse_pos_global = get_global_mouse_position()
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

var clicks=-5

func select_hex(cellPos: Vector2i):
	selMarker.position = map_to_local(cellPos)
	
	#set_on_fire(cellPos)
	#set_on_water(cellPos)
	#set_on_tornado(cellPos)
	#set_on_quake(cellPos)
	#set_on_tsunami(cellPos)
	#tsunami_wave(Vector2i(6,5), 3)
	#tsunami_wave(Vector2i(14,4), 3)
	#tsunami_wave(Vector2i(22,7), 3)
	#tsunami_wave(Vector2i(8,13), 3)
	#tsunami_wave(Vector2i(19,14), 3)
	
	#HERE
	#var countrySpawnCells = [Vector2i(6,5), Vector2i(14,4), Vector2i(22,7), Vector2i(8,13), Vector2i(19,14)]
	#var numberOfCountries = 4
	#for cell in countrySpawnCells:
		#currentRange=2
		#country_wave(cell, currentRange, 6, 4-numberOfCountries)
		#numberOfCountries-=1
	#numberOfCountries = 4
	#currentRange=2
	#
	#if clicks>=0:
		#for i in range(0,5):
			#generate_Plain_city(i)
			#generate_Mountain_city(i)
			#generate_River_city(i)
	#else:
		#clicks+=1
		#
		#generate_river(cellPos)
	#HERE
	
	#print("ClickPos", cellPos)
	currentRange=2
	tsunami_wave(cellPos, currentRange, 5)
	currentRange=2

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

func get_is_water(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_water: float = data.get_custom_data("isWater")
		if is_water == 1:
			return true
	return false

func get_is_river(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("rivermap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var is_river: float = data.get_custom_data("isRiver")
		if is_river == 1:
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

func get_country_number(tile_pos) -> int:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("countrymap")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var countryNumber: int = data.get_custom_data("countryNumber")
		return countryNumber
	return 10	

func set_on_fire(tile_pos) -> void:
	$"../fire".set_cell (Vector2i(tile_pos), 1, Vector2i.ZERO, 1)
	print("fire added")

func set_on_water(tile_pos) -> void:
	$"../water".set_cell (Vector2i(tile_pos), 1, Vector2i.ZERO, 0)
	print("water added")

func set_on_tornado(tile_pos) -> void:
	$"../tornado".set_cell (Vector2i(tile_pos), 0, Vector2i.ZERO, 0)
	print("tornado added")

func set_on_quake(tile_pos) -> void:
	$"../quake".set_cell (Vector2i(tile_pos), 0, Vector2i.ZERO, 0)
	print("quake added")

func set_on_tsunami(tile_pos) -> void:
	$"../tsunami".set_cell(Vector2i(tile_pos), 0, Vector2i.ZERO, 0)
	$"../tsunami".set_cell(tile_pos+Vector2i(0,1), 0, Vector2i.ZERO, 0)
	$"../tsunami".set_cell(tile_pos+Vector2i(0,-1), 0, Vector2i.ZERO, 0)
	$"../tsunami".set_cell(tile_pos+Vector2i(1,0), 0, Vector2i.ZERO, 0)
	$"../tsunami".set_cell(tile_pos+Vector2i(-1,0), 0, Vector2i.ZERO, 0)
	if (tile_pos[0]%2==0):
		$"../tsunami".set_cell(tile_pos+Vector2i(1,-1), 0, Vector2i.ZERO, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(-1,-1), 0, Vector2i.ZERO, 0)
	else:
		$"../tsunami".set_cell(tile_pos+Vector2i(1,1), 0, Vector2i.ZERO, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(-1,1), 0, Vector2i.ZERO, 0)

func tsunami_wave(tile_pos, currentRange, waveRange) -> void:
	var directions = []
	set_on_tsunami(tile_pos)
	var top = tile_pos+Vector2i(0,1)
	if get_is_water(top):
		directions.append(top)
	var bot = tile_pos+Vector2i(0,-1)
	if get_is_water(bot):
		directions.append(bot)
	var top_right = Vector2i()
	var top_left = Vector2i()
	var bot_right = Vector2i()
	var bot_left = Vector2i()
	if tile_pos[0]%2==0:
		top_right = tile_pos+Vector2i(1,-1)
		if get_is_water(top_right):
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,-1)
		if get_is_water(top_left):
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,0)
		if get_is_water(bot_right):
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,0)
		if get_is_water(bot_left):
			directions.append(bot_left)
	else:
		top_right = tile_pos+Vector2i(1,0)
		if get_is_water(top_right):
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,0)
		if get_is_water(top_left):
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,1)
		if get_is_water(bot_right):
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,1)
		if get_is_water(bot_left):
			directions.append(bot_left)
	for direction in directions:
		if (direction[0]>=3 && direction[0]<map_width-3) && (direction[1]>=3 && direction[1]<map_height-3):
			set_on_tsunami(direction)
	if currentRange < waveRange:
		currentRange+=1
		for direction in directions:
			tsunami_wave(direction, currentRange, waveRange)

func set_country_territory(tile_pos, countryNumber) -> void:
	if get_country_number(tile_pos) == 10:
		$"../countries".set_cell(Vector2i(tile_pos), countryNumber, Vector2i.ZERO, 0)
	if get_country_number(tile_pos+Vector2i(0,1)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(0,1), countryNumber, Vector2i.ZERO, 0)
	if get_country_number(tile_pos+Vector2i(0,-1)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(0,-1), countryNumber, Vector2i.ZERO, 0)
	if get_country_number(tile_pos+Vector2i(1,0)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(1,0), countryNumber, Vector2i.ZERO, 0)
	if get_country_number(tile_pos+Vector2i(-1,0)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(-1,0), countryNumber, Vector2i.ZERO, 0)
	if (tile_pos[0]%2==0):
		if get_country_number(tile_pos+Vector2i(1,-1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(1,-1), countryNumber, Vector2i.ZERO, 0)
		if get_country_number(tile_pos+Vector2i(-1,-1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(-1,-1), countryNumber, Vector2i.ZERO, 0)
	else:
		if get_country_number(tile_pos+Vector2i(1,1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(1,1), countryNumber, Vector2i.ZERO, 0)
		if get_country_number(tile_pos+Vector2i(-1,1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(-1,1), countryNumber, Vector2i.ZERO, 0)

var currentRange = 1

func country_wave(tile_pos, currentRange, countryRange, countryNumber) -> void:
	var directions = []
	if (tile_pos[0]>=3 && tile_pos[0]<map_width-3) && (tile_pos[1]>=3 && tile_pos[1]<map_height-3):
		set_country_territory(tile_pos, countryNumber)
	var top = tile_pos+Vector2i(0,1)
	if get_country_number(top)==10 || get_country_number(top)==countryNumber:
		directions.append(top)
	var bot = tile_pos+Vector2i(0,-1)
	if get_country_number(bot)==10 || get_country_number(bot)==countryNumber:
		directions.append(bot)
	var top_right = Vector2i()
	var top_left = Vector2i()
	var bot_right = Vector2i()
	var bot_left = Vector2i()
	if tile_pos[0]%2==0:
		top_right = tile_pos+Vector2i(1,-1)
		if get_country_number(top_right)==10 || get_country_number(top_right)==countryNumber:
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,-1)
		if get_country_number(top_left)==10 || get_country_number(top_left)==countryNumber:
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,0)
		if get_country_number(bot_right)==10 || get_country_number(bot_right)==countryNumber:
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,0)
		if get_country_number(bot_left)==10 || get_country_number(bot_left)==countryNumber:
			directions.append(bot_left)
	else:
		top_right = tile_pos+Vector2i(1,0)
		if get_country_number(top_right)==10 || get_country_number(top_right)==countryNumber:
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,0)
		if get_country_number(top_left)==10 || get_country_number(top_left)==countryNumber:
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,1)
		if get_country_number(bot_right)==10 || get_country_number(bot_right)==countryNumber:
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,1)
		if get_country_number(bot_left)==10 || get_country_number(bot_left)==countryNumber:
			directions.append(bot_left)
	for direction in directions:
		if (direction[0]>=3 && direction[0]<map_width-3) && (direction[1]>=3 && direction[1]<map_height-3):
			set_country_territory(direction, countryNumber)
	if currentRange < countryRange:
		currentRange+=1
		for direction in directions:
			country_wave(direction, currentRange, countryRange, countryNumber)
