extends Control
@onready var v_scroll_bar: VScrollBar = $"../VBoxContainer/HBoxContainer/BackButtonPanel/VScrollBar"

@onready var research_tier: Control = $"."
@export var x = 0
@export var y = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var y = research_tier.global_position.y
	var x = research_tier.global_position.x



func _on_v_scroll_bar_value_changed(value: float) -> void:
	var new_positon = Vector2(x,y+v_scroll_bar.value)
	research_tier.set_global_position(new_positon)
