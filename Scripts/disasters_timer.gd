extends Timer

var canFire = 1
var canQuake = 1

func _ready():
	$".".start(10)

func _on_timeout():
	print("TRIGGER")
	if randi()%2==0:
		Global.randomTile = Vector2i(randi()%28,randi()%18)
		print("GLOBAL",Global.randomTile)
		match(randi()%2): #randi()%6
			0:
				print('0')
				if (canFire == 1):
					$"../map/worldGen".set_on_fire(Global.randomTile,0,1)
					$".".start(10)
					$fireTimer.start(30)
					canFire = 0
			1:
				print('1')
				if (canQuake == 1):
					$"../map/worldGen".set_on_quake(Global.randomTile)
					$".".start(10)
					$quakeTimer.start(30)
					canQuake = 0
			2:
				print('2')
			3:
				print('3')
			4:
				print('4')
			5:
				print('5')
		print("Success")
	else:
		print("Fail")

func _on_fire_timer_timeout():
	canFire = 1

func _on_quake_timer_timeout():
	canQuake = 1
