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
var forestArray = []

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
	forestArray.clear()

var mapDone = 0

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
						if Vector2i(x,y) not in forestArray:
							forestArray.append(Vector2i(x,y))
				randomize()
				if randi()%2==1:
					if randi()%2==0:
						$"../forest2Layer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
						if Vector2i(x,y) not in forestArray:
							forestArray.append(Vector2i(x,y))
				randomize()
				if randi()%2==0:
					if randi()%2==1:
						$"../forest3Layer".set_cell (Vector2i(x,y), 0, Vector2i(0,0), 0)
						if Vector2i(x,y) not in forestArray:
							forestArray.append(Vector2i(x,y))
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
		mapDone=1
		if mapDone && (citiesNotGenerated==1):
			var countrySpawnCells = [Vector2i(6,5), Vector2i(14,4), Vector2i(22,7), Vector2i(8,13), Vector2i(19,14)]
			var numberOfCountries = 4
			for cell in countrySpawnCells:
				currentRange=2
				country_wave(cell, currentRange, 6, 4-numberOfCountries)
				numberOfCountries-=1
			numberOfCountries = 4
			currentRange=2
			for i in range(0,5):
				generate_Plain_city(i)
				generate_Plain_city(i)
				generate_Plain_city(i)
				generate_Plain_city(i)
				generate_Mountain_city(i)
			citiesNotGenerated=0

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
					$"../cityLayer".set_cell (cityLocation, 2, Vector2i(0,0), 0)

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
				if (randi()%2==1):
					$"../cityLayer".set_cell (cityLocation, 1, Vector2i(0,0), 0)
				else:
					$"../cityLayer".set_cell (cityLocation, 2, Vector2i(0,0), 0)

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
		if (isTeamDeployed==0):
			if Input.is_action_just_pressed("deployTroops"):
				deploy_team(tile_pos)
	else:
		highlight_hex(Vector2i(-2,-2))

func highlight_hex(cellPos: Vector2i):
	marker.position = map_to_local(cellPos)

var clicks=-5
var citiesNotGenerated=1

var isTeamDeployed=0
var deployableTeam=1

var teamDeployLocation = Vector2i.ZERO

func deploy_team(tile_pos) -> void:
	print("DEPLO",deployableTeam)
	if deployableTeam==1:
		isTeamDeployed=1
		print("DEPLOYED")
		teamDeployLocation = Vector2i(tile_pos[0],tile_pos[1])
		$"../../teamTimer".paused = false
		$"../../teamTimer".start(5)
	elif deployableTeam==0:
		isTeamDeployed=0
		print("DONE DEPLOYING")
		$"../../teamTimer".paused = true
		$"../water".set_cell(teamDeployLocation,-1,Vector2i.ZERO,0)
		$"../quake".set_cell(teamDeployLocation,-1,Vector2i.ZERO,0)
		$"../tsunami".set_cell(teamDeployLocation,-1,Vector2i.ZERO,0)
		$"../fire".set_cell(teamDeployLocation,-1,Vector2i.ZERO,0)
		$"../tornado".set_cell(teamDeployLocation,-1,Vector2i.ZERO,0)
		$"../../disastersTimer/fireTimer/fireExtension".stop()
		deployableTeam=1

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
	
	
			#generate_River_city(i)
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
	#currentRange=2
	#tsunami_wave(cellPos, currentRange, 5)
	#currentRange=2

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

var randomFire = Vector2i.ZERO
var addedRandomFire = 0

func set_on_fire(tile_pos, add) -> void:
	var top_right = Vector2i.ZERO
	var top_left = Vector2i.ZERO
	var bot_right = Vector2i.ZERO
	var bot_left = Vector2i.ZERO
	if get_has_forest(tile_pos) || get_has_forest2(tile_pos) || get_has_forest3(tile_pos):
			$"../fire".set_cell (tile_pos, add, Vector2i.ZERO, 1)
			print("fire added")
			addedRandomFire = 0
	elif add==-1:
		if addedRandomFire == 1:
			tile_pos = randomFire
		else:
			tile_pos = forestArray[0]
		$"../fire".set_cell (Vector2i(tile_pos), add, Vector2i.ZERO, 1)
		print("random fire deleted")
		addedRandomFire = 0
	else:
		forestArray.shuffle()
		$"../fire".set_cell (Vector2i(forestArray[0]), 1, Vector2i.ZERO, 1)
		tile_pos = forestArray[0]
		print("random fire added")
		addedRandomFire = 1
		randomFire = tile_pos
	if add==-1:
		if addedRandomFire == 1:
			tile_pos = randomFire
		if tile_pos[0]%2==0:
			top_right = tile_pos+Vector2i(1,-1)
			top_left = tile_pos+Vector2i(-1,-1)
			bot_right = tile_pos+Vector2i(1,0)
			bot_left = tile_pos+Vector2i(-1,0)
		else:
			top_right = tile_pos+Vector2i(1,0)
			top_left = tile_pos+Vector2i(-1,0)
			bot_right = tile_pos+Vector2i(1,1)
			bot_left = tile_pos+Vector2i(-1,1)
		$"../fire".set_cell (tile_pos+Vector2i(0,1), add, Vector2i.ZERO, 1)
		$"../fire".set_cell (tile_pos+Vector2i(0,-1), add, Vector2i.ZERO, 1)
		$"../fire".set_cell (top_right, add, Vector2i.ZERO, 1)
		$"../fire".set_cell (top_left, add, Vector2i.ZERO, 1)
		$"../fire".set_cell (bot_right, add, Vector2i.ZERO, 1)
		$"../fire".set_cell (bot_left, add, Vector2i.ZERO, 1)

func set_on_water(tile_pos, add) -> void:
	$"../water".set_cell (Vector2i(tile_pos), add, Vector2i.ZERO, 0)
	print("water added")

func set_on_tornado(tile_pos, add) -> void:
	$"../tornado".set_cell (Vector2i(tile_pos), add, Vector2i.ZERO, 0)
	print("tornado added")

func set_on_quake(tile_pos, add) -> void:
	if get_is_plain(tile_pos) || (get_is_mountain(tile_pos) && !get_is_peak((tile_pos))):
		print("QUAKE AVAILABLE", tile_pos)
		$"../quake".set_cell (Vector2i(tile_pos), add, Vector2i.ZERO, 0)
	else:
		if randi()%2==0:
			plainArray.shuffle()
			tile_pos = plainArray[0]
		else:
			mountainArray.shuffle()
			while mountainArray[0] in peakArray:
				mountainArray.shuffle()
			tile_pos = mountainArray[0]
		print("PL",plainArray[0],"TP",tile_pos)
		print("PL2",plainArray[0][0],"PL3",plainArray[0][1],"PL4")
		$"../quake".set_cell (Vector2i(tile_pos[0],tile_pos[1]), add, Vector2i.ZERO, 0)
	print("quake added")

var tsunamiTile = Vector2i.ZERO

func set_on_tsunami(tile_pos,add) -> void:
	if add == -1 and tsunamiTile != Vector2i.ZERO:
		pass
	else:
		$"../tsunami".set_cell(Vector2i(tile_pos), add, tsunamiTile, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(0,1), add, tsunamiTile, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(0,-1), add, tsunamiTile, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(1,0), add, tsunamiTile, 0)
		$"../tsunami".set_cell(tile_pos+Vector2i(-1,0), add, tsunamiTile, 0)
		if (tile_pos[0]%2==0):
			$"../tsunami".set_cell(tile_pos+Vector2i(1,-1), add, tsunamiTile, 0)
			$"../tsunami".set_cell(tile_pos+Vector2i(-1,-1), add, tsunamiTile, 0)
		else:
			$"../tsunami".set_cell(tile_pos+Vector2i(1,1), add, tsunamiTile, 0)
			$"../tsunami".set_cell(tile_pos+Vector2i(-1,1), add, tsunamiTile, 0)

func tsunami_wave(tile_pos, currentRange, waveRange,add) -> void:
	var directions = []
	if get_is_plain(tile_pos):
		tsunamiTile = Vector2i(9,0)
	elif get_is_water(tile_pos):
		tsunamiTile = Vector2i.ZERO
	elif get_is_mountain(tile_pos):
		if (!get_is_peak(tile_pos)):
			tsunamiTile = Vector2i(9,0)
	set_on_tsunami(tile_pos,add)
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
			set_on_tsunami(direction,add)
	if currentRange < waveRange:
		currentRange+=1
		for direction in directions:
			tsunami_wave(direction, currentRange, waveRange,add)

func get_has_forest(tile_pos) -> bool:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("hasForest")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
		
	if data:
		var has_forest: float = data.get_custom_data("hasForest")
		if has_forest == 1:
			return true
	return false

func get_has_forest2(tile_pos) -> bool:
	var tilemap = get_tree().get_first_node_in_group("hasForest2")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
		
	if data:
		var has_forest2: float = data.get_custom_data("hasForest2")
		if has_forest2 == 1:
			return true
	return false

func get_has_forest3(tile_pos) -> bool:
	var tilemap = get_tree().get_first_node_in_group("hasForest3")
	var cell = tile_pos
	var data: TileData = tilemap.get_cell_tile_data(cell)
		
	if data:
		var has_forest3: float = data.get_custom_data("hasForest3")
		if has_forest3 == 1:
			return true
	return false

func fire_wave(tile_pos) -> void:
	if addedRandomFire==1:
		tile_pos = randomFire
	var directions = []
	var top = tile_pos+Vector2i(0,1)
	print ("1", get_has_forest(top), "2", get_has_forest2(top), "3", get_has_forest3(top))
	print("wha", get_has_forest(top) || get_has_forest2(top) || get_has_forest3(top))
	if get_has_forest(top) || get_has_forest2(top) || get_has_forest3(top):
		directions.append(top)
	var bot = tile_pos+Vector2i(0,-1)
	if get_has_forest(bot) || get_has_forest2(bot) || get_has_forest3(bot):
		directions.append(bot)
	var top_right = Vector2i()
	var top_left = Vector2i()
	var bot_right = Vector2i()
	var bot_left = Vector2i()
	if tile_pos[0]%2==0:
		top_right = tile_pos+Vector2i(1,-1)
		if get_has_forest(top_right) || get_has_forest2(top_right) || get_has_forest3(top_right):
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,-1)
		if get_has_forest(top_left) || get_has_forest2(top_left) || get_has_forest3(top_left):
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,0)
		if get_has_forest(bot_right) || get_has_forest2(bot_right) || get_has_forest3(bot_right):
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,0)
		if get_has_forest(bot_left) || get_has_forest2(bot_left) || get_has_forest3(bot_left):
			directions.append(bot_left)
	else:
		top_right = tile_pos+Vector2i(1,0)
		if get_has_forest(top_right) || get_has_forest2(top_right) || get_has_forest3(top_right):
			directions.append(top_right)
		top_left = tile_pos+Vector2i(-1,0)
		if get_has_forest(top_left) || get_has_forest2(top_left) || get_has_forest3(top_left):
			directions.append(top_left)
		bot_right = tile_pos+Vector2i(1,1)
		if get_has_forest(bot_right) || get_has_forest2(bot_right) || get_has_forest3(bot_right):
			directions.append(bot_right)
		bot_left = tile_pos+Vector2i(-1,1)
		if get_has_forest(bot_left) || get_has_forest2(bot_left) || get_has_forest3(bot_left):
			directions.append(bot_left)
	print("directions",directions)
	for direction in directions:
		$"../fire".set_cell (direction, 1, Vector2i.ZERO, 1)

var alternateC = 0

func set_country_territory(tile_pos, countryNumber) -> void:
	if get_country_number(tile_pos) == 10:
		$"../countries".set_cell(Vector2i(tile_pos), countryNumber, Vector2i.ZERO, alternateC)
	if get_country_number(tile_pos+Vector2i(0,1)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(0,1), countryNumber, Vector2i.ZERO, alternateC)
	if get_country_number(tile_pos+Vector2i(0,-1)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(0,-1), countryNumber, Vector2i.ZERO, alternateC)
	if get_country_number(tile_pos+Vector2i(1,0)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(1,0), countryNumber, Vector2i.ZERO, alternateC)
	if get_country_number(tile_pos+Vector2i(-1,0)) == 10:
		$"../countries".set_cell(tile_pos+Vector2i(-1,0), countryNumber, Vector2i.ZERO, alternateC)
	if (tile_pos[0]%2==0):
		if get_country_number(tile_pos+Vector2i(1,-1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(1,-1), countryNumber, Vector2i.ZERO, alternateC)
		if get_country_number(tile_pos+Vector2i(-1,-1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(-1,-1), countryNumber, Vector2i.ZERO, alternateC)
	else:
		if get_country_number(tile_pos+Vector2i(1,1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(1,1), countryNumber, Vector2i.ZERO, alternateC)
		if get_country_number(tile_pos+Vector2i(-1,1)) == 10:
			$"../countries".set_cell(tile_pos+Vector2i(-1,1), countryNumber, Vector2i.ZERO, alternateC)

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

func _on_team_timer_timeout() -> void:
	print("DEP0")
	deployableTeam=0
	$"../../teamTimer".stop()
	deploy_team(teamDeployLocation)
