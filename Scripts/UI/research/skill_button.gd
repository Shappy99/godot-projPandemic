extends Button
class_name SkillNode
@onready var texture_rect: TextureRect = $TextureRect
@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D


const skillButtonIcon := preload("res://skill_placeholder.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.set_texture(skillButtonIcon)
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)

var level: int = 0:
	set(value):
		level = value
		label.text = str(level) + "/3"


func _on_pressed() -> void:
	level = min(level+1,3)
	panel.show_behind_parent = true
	
