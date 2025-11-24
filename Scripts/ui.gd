extends Control

@export var map_gen : worldGenerator = null
@onready var hud: Control = $HUD
@onready var pause_menu: Panel = $"Pause Menu"

@export var is_paused = false

func _ready() -> void:
	hud.visible = true
	pause_menu.visible = false
	get_tree().paused = false


func _on_button_button_down():
	map_gen.generate_map()
	print("Map Gen")


func _on_resume_button_pressed() -> void:
	hud.visible = true
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_button_pressed() -> void:
	hud.visible = false
	pause_menu.visible = true
	get_tree().paused = true


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
