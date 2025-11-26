extends Timer

var alreadyOnFire = 0

func _ready():
	$".".start(10)

func _on_timeout():
	if alreadyOnFire == 0:
		get_node("/root/main/map/worldGen").set_on_fire(Vector2i.ZERO, 1, 1)
		print("OK")
		$".".stop()
		$"../runOutTimer".start(30)
		alreadyOnFire = 1

func _on_run_out_timer_timeout():
	get_node("/root/main/map/worldGen").set_on_fire(Vector2i.ZERO, 1, -1)
	alreadyOnFire = 0
