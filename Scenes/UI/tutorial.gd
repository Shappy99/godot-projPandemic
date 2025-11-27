extends Control

@export var map_gen : worldGenerator = null

func _on_yes_button_button_down():
	$Tiles.show()
	$Panel.hide()

func _on_next_button_1_button_down():
	$Disasters.show()
	$Tiles.hide()

func _on_next_button_2_button_down():
	$Disasters2.show()
	$Disasters.hide()

func _on_next_button_3_button_down():
	$Disasters3.show()
	$Disasters2.hide()

func _on_next_button_4_button_down():
	$Disasters4.show()
	$Disasters3.hide()

func _on_next_button_5_button_down():
	$Disasters5.show()
	$Disasters4.hide()

func _on_next_button_6_button_down():
	$Disasters6.show()
	$Disasters5.hide()

func _on_start_game_button_button_down():
	print("OK")
	$"..".startGame()
