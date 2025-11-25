extends Button
@onready var texture_rect: TextureRect = $TextureRect
@onready var panel: Panel = $Panel
@onready var label: Label = $PanelContainer/Label

const skillButtonIcon := preload("res://skill_placeholder.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.set_texture(skillButtonIcon)

var level: int = 0:
	set(value):
		level = value
		label.text = str(level) + "/1"


func _on_pressed() -> void:
	level = min(level+1,1)
	panel.show_behind_parent = true
