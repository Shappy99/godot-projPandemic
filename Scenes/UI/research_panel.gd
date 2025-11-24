extends VBoxContainer
@onready var label: Label = $Label
@onready var research: Control = $"../../.."
@onready var hud: Control = $"../../../../GUI/HUD"
@onready var time_funds_container: VBoxContainer = $"../../../../GUI/HUD/Timer/TimeFundsContainer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_3_toggled(toggled_on: bool) -> void:
	label.text = "Fire Fighter"



func _on_button_4_toggled(toggled_on: bool) -> void:
	label.text = "Search N Rescue"

func _on_back_button_pressed() -> void:
	time_funds_container.visible = true
	hud.visible=true
	research.visible=false
