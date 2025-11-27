extends Timer

var randomTileTsunami = Vector2i.ZERO
var randomTileFire = Vector2i.ZERO
var randomTileQuake = Vector2i.ZERO
var randomRiverFlood = Vector2i.ZERO
var randomTileTornado = Vector2i.ZERO
var canTsunami = 1
var canFire = 1
var canQuake = 1
var canFlood = 1
var canTornado = 1
var failedRolls = 0
var rollSucces = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func _on_timeout() -> void:
	match (failedRolls):
		0:
			if randi()%3==1:
				print("0 succes")
				rollSucces=1
			else:
				failedRolls=1
				print("0 fail")
				rollSucces=0
		1: 
			if randi()%2==1:
				print("1 succes")
				rollSucces=1
			else: 
				failedRolls=2
				print("1 fail")
				rollSucces=0
		2:
			print("2")
			rollSucces=1
			failedRolls=0
	while (rollSucces==1):
		if (canTsunami == 1 or canFire == 1 or canQuake == 1 or canFlood == 1 or canTornado == 1):
			match (randi()%5):
				0:
					print("tsunami")
					if (canTsunami == 1):
						randomTileTsunami = Vector2i(2+randi()%24,2+randi()%14)
						var currentRange = 2
						$"../map/worldGen".tsunami_wave(randomTileTsunami, currentRange, 5,0)
						$".".start(10)
						$tsunamiTimer.start(30)
						canTsunami = 0
						failedRolls=0
						rollSucces=0
				1:
					print("fire")
					if (canFire == 1):
						randomTileFire = Vector2i(2+randi()%24,2+randi()%14)
						$"../map/worldGen".set_on_fire(randomTileFire,1)
						$".".start(10)
						$fireTimer.start(30)
						$fireTimer/fireExtension.start(15)
						canFire = 0
						failedRolls=0
						rollSucces=0
				2:
					print("miniQuake")
					if (canQuake == 1):
						randomTileQuake = Vector2i(2+randi()%24,2+randi()%14)
						$"../map/worldGen".set_on_quake(randomTileQuake,0)
						print("??",randomTileQuake)
						$".".start(10)
						canQuake = 0
						failedRolls=0
						rollSucces=0
				3:
					print("flood")
					if (canFlood == 1):
						randomRiverFlood = Vector2i(2+randi()%24,2+randi()%14)
						$"../map/worldGen".set_on_water(randomRiverFlood,1)
						$".".start(10)
						$floodTimer.start(30)
						canFlood = 0
						rollSucces=0
				4:
					print("tornado")
					if (canTornado == 1):
						randomTileTornado = Vector2i(2+randi()%24,2+randi()%14)
						$"../map/worldGen".set_on_tornado(randomTileTornado,0)
						$".".start(10)
						$tornadoTimer.start(30)
						canTornado = 0
						rollSucces=0
			failedRolls=0
		else: rollSucces=0
	$".".start(10)
func _on_tsunami_timer_timeout() -> void:
	print("tsu")
	canTsunami = 1
	var currentRange = 2
	$"../map/worldGen".tsunami_wave(randomTileTsunami, currentRange, 5,-1)
	$tsunamiTimer.stop()

func _on_fire_timer_timeout() -> void:
	print("fir")
	canFire = 1
	$"../map/worldGen".set_on_fire(randomTileFire,-1)
	$fireTimer.stop()

func _on_flood_timer_timeout() -> void:
	print("flo")
	canFlood = 1
	$"../map/worldGen".set_on_water(randomRiverFlood,-1)
	$floodTimer.stop()

func _on_tornado_timer_timeout() -> void:
	print("tor")
	canTornado = 1
	$"../map/worldGen".set_on_tornado(randomTileTornado,-1)
	$tornadoTimer.stop()

func _on_fire_extension_timeout() -> void:
	$"../map/worldGen".fire_wave(randomTileFire)
	$fireTimer/fireExtension.stop()
