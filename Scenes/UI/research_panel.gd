extends Control
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_3_toggled(toggled_on: bool) -> void:
	label.text = "Fire Fighter"



func _on_button_4_toggled(toggled_on: bool) -> void:
	label.text = "Search N Rescue"
