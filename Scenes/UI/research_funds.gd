extends Label
@onready var funds_label: Label = $"../../../../../../GUI/HUD/Timer/TimeFundsContainer/fundsLabel"
@onready var research_funds: Label = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	research_funds.text = funds_label.text
