extends Control

@export var map_gen : worldGenerator = null

func _on_button_button_down():
	map_gen.generate_map()
	print("Map Gen")
