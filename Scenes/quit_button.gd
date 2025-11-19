extends Button


func _on_button_down():
	get_tree().quit()


func _on_credits_button_button_down():
	$"../..".hide()
	$"../../../MarginContainer2".show()

func _on_button_button_down():
	$"../../../MarginContainer2".hide()
	$"../..".show()

func _on_play_button_button_down():
	$"../../..".hide()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
