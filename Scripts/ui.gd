extends Control

@export var map_gen : worldGenerator = null

func _on_button_button_down():
	map_gen.generate_map()

func _input(event):
	if event.is_action_pressed("pressingEsc"):
		if get_tree().paused == false:
			get_tree().paused = true
			$pauseMenu.show()
		else:
			get_tree().paused = false
			$pauseMenu.hide()

func _on_unpause_button_button_down():
	$pauseMenu.hide()
	get_tree().paused = false

func _on_return_button_button_down():
	$".".hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
